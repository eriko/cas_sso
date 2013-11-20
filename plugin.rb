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
#gem 'omniauth-cas', '1.0.4'




class CASAuthenticator < ::Auth::Authenticator


  def name
    'cas'
  end

  def after_authenticate(auth_token)
    result = Auth::Result.new
    #if the email address is set in the extra attributes and we know the accessor use it here
    email = auth_token[:extra][SiteSetting.cas_sso_email] if (auth_token[:extra] && auth_token[:extra][SiteSetting.cas_sso_email])
    #if we could not get the email address from the extra attributes try to set it base on the username
    email ||= unless SiteSetting.cas_sso_email_domain.nil?
                "#{auth_token[:uid]}@#{SiteSetting.cas_sso_email_domain}"
              else
                auth_token[:uid]
              end

    result.email = email
    result.email_valid = true

    result.username = auth_token[:uid]

    result.name = if auth_token[:extra] && auth_token[:extra][SiteSetting.cas_sso_name]
                    auth_token[:extra][SiteSetting.cas_sso_name]
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
    user.update_attribute(:approved, SiteSetting.cas_sso_user_approved)
    ::PluginStore.set("cas", "cas_uid_#{auth[:username]}", {user_id: user.id})
  end


  def register_middleware(omniauth)
    Rails.logger.info "in cas_sso plugin with omniauth of #{omniauth}"

    omniauth.provider :cas,
                      :setup => lambda { |env|
                        strategy = env["omniauth.strategy"]
                        strategy.options[:host] = SiteSetting.cas_sso_host
                        strategy.options[:port] = SiteSetting.cas_sso_port
                        strategy.options[:path] = SiteSetting.cas_sso_path
                        strategy.options[:ssl] = SiteSetting.cas_sso_ssl
                        strategy.options[:service_validate_url] = SiteSetting.cas_sso_service_validate_url
                        strategy.options[:login_url] = SiteSetting.cas_sso_login_url
                        strategy.options[:logout_url] = SiteSetting.cas_sso_logout_url
                        strategy.options[:uid_key] = SiteSetting.cas_sso_uid_key
                      }
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