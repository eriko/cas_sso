# name: CAS
# about: Authenticate with discourse with CAS
# version: 0.1.0
# author: Erik Ordway
require 'rubygems'
#require_relative './../../app/models/site_setting'
#require '../../app/models/site_setting'


#addressable is set to require: false as the cas code will
# load the actual part that it needs at runtime.
gem 'addressable', '2.3.5', require: false
gem 'omniauth-cas', '1.0.4'

after_initialize do
  #The SiteSettings seems to be processed into the application after the processing of after_initialize so include it now.
  require File.expand_path('../../../app/models/site_setting', __FILE__)


  #Required settings
  SiteSetting.setting(:plugin_cas_sso_url,
                      'https://YOUR.CAS.SEVER/cas',
                      {description: 'Full url of your CAS server'})
  #setting(:plugin_cas_sso_url, 'https://YOUR.CAS.SEVER/cas')

  # Optional settings

  #The attribute name in extra attributes for display name.
  #If the attribute can not be found the username will be used instead.
  SiteSetting.setting(:plugin_cas_sso_name,
                      'Name',
                      {description: 'Attribute in CAS return values that is the users display name'})
  #setting(:plugin_cas_sso_email, ':Name')
  #attribute name in extra attributes for email address
  SiteSetting.setting(:plugin_cas_sso_email,
                      'UserPrincipalName',
                      {description: 'Attribute in CAS return values that is the users email address'})
  #setting(:plugin_cas_sso_email, ':UserPrincipalName')
  #if the above is not set the plugin will set the
  #email address to username@CAS_EMAIL_DOMAIN if CAS_EMAIL_DOMAIN is set.
  #otherwise it will be set to username@
  SiteSetting.setting(:plugin_cas_sso_email_domain,
                      'YOUR.EMAIL.DOMAIN',
                      {description: 'domain name to use in creating email address if one is not available in the CAS return attributes'})
  #setting(:plugin_cas_sso_email_domain, 'YOUR.EMAIL.DOMAIN')


  #Automatically approve the new user
  SiteSetting.setting(:plugin_cas_sso_user_approved,
                      true,
                      {description: 'Automatically approve users that are created via CAS'})
  #setting(:plugin_cas_sso_user_approved, true)
  SiteSetting.refresh!

end


class CASAuthenticator < ::Auth::Authenticator


  def name
    'cas'
  end

  def after_authenticate(auth_token)
    result = Auth::Result.new
    #if the email address is set in the extra attributes and we know the accessor use it here
    email = auth_token[:extra][SiteSetting.plugin_cas_sso_email] if (auth_token[:extra] && auth_token[:extra][SiteSetting.plugin_cas_sso_email])
    #if we could not get the email address from the extra attributes try to set it base on the username
    email ||= unless SiteSetting.plugin_cas_sso_email_domain.nil?
                "#{auth_token[:uid]}@#{SiteSetting.plugin_cas_sso_email_domain}"
              else
                auth_token[:uid]
              end

    result.email = email
    result.email_valid = true

    result.username = auth_token[:uid]

    result.name = if auth_token[:extra] && auth_token[:extra][SiteSetting.plugin_cas_sso_name]
                    auth_token[:extra][SiteSetting.plugin_cas_sso_name]
                  else
                    auth_token[:uid]
                  end

    # plugin specific data storage
    current_info = ::PluginStore.get("cas", "cas_uid_#{auth_token[:uid]}")
    result.user =
        if current_info
          User.where(id: current_info[:user_id]).first
        end
    result.user ||= User.where(email: email).first

    result
  end

  def after_create_account(user, auth)
    user.update_attribute(:approved, SiteSetting.plugin_cas_sso_user_approved)
    ::PluginStore.set("cas", "cas_uid_#{auth[:username]}", {user_id: user.id})
  end


  def register_middleware(omniauth)

    #by seting :setup => true should configure the strategy at execution per
    # https://github.com/intridea/omniauth/wiki/Setup-Phase
    #omniauth.provider :cas, :url => CAS_URL, :setup => true
    omniauth.provider :cas, :url => SiteSetting.plugin_cas_sso_url, :setup => true
  end
end


auth_provider :title => 'with CAS',
              :message => 'Log in via CAS (Make sure pop up blockers are not enabled).',
              :frame_width => 920,
              :frame_height => 800,
              :authenticator => CASAuthenticator.new


register_css <<CSS

.btn-social.cas {
  background: #70BA61;
}

.btn-social.cas:before {
  font-family: Ubuntu;
  content: "C";
}

CSS