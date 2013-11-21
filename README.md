cas_sso
=======
CAS based single sign on for Discourse in plugin form.


Installation
------------

* Run `rake plugin:install repo=https://github.com/eriko/cas_sso` in your discourse directory
* In development mode, run `rake assets:clean`
* In production, recompile your assets: `rake assets:precompile`

Until the omniauth-cas gem that supports dynamic setup is released (it should be soon) you need to add the master branch
to your Gemfile.

Then add
    `gem 'omniauth-cas'     , git: 'https://github.com/dlindahl/omniauth-cas.git', branch: 'master'`

to your Gemfile or add
    `, git: 'https://github.com/dlindahl/omniauth-cas.git', branch: 'master'`

to the existing
    `gem 'omniauth-cas'`

if it already exists.

  As usual now you will have to run `bundle install` and restart the application.
The initial restart maybe a little slower than usual as the plugin also installs any plugins that it needs.
 In this case that is `addressable`.  This slow down should be a one time event unless the plugin is updated.


Setup
-----
You will need to got to http://YOUR.DISCOURSE.SERVER/admin/site_settings/category/cas_sso  and configure some settings.
At minimum you will need to set the `plugin_cas_sso_url` .  If your cas server is configured in a manner out of the norm
you may need to use the other settings.  To do so wipe out `plugin_cas_sso_url` setting as it will override the other settings like

  `
  cas_sso_host:
    default: 'YOUR.CAS.SERVER'`

  `cas_sso_port:
    default: '443'`

  `cas_sso_path:
    default: ''`

  `cas_sso_ssl:
    default: true`

  `cas_sso_login_url:
    default: '/login'`

  `cas_sso_logout_url:
    default: '/logout'`

  `cas_sso_service_validate_url:
    default: '/service_validate_url'`

  `cas_sso_uid_field:
    default: 'user' 
    `

These are set to reasonable defaults but if you need to use them to deal if an oddly configured CAS then they are just a starting point.

Required settings
-----------------
Full uri for your CAS server.  Some servers are use a trailing */cas* and some do not.
*  plugin_cas_sso_url = 'https://YOUR.CAS.SERVER/cas'

OR

empty out the cas_sso_url setting and adjust the rest to what you need.  The defaults are the standard settings.

Optional settings
-----------------
These allow you to use the extra attributes that CAS can return if your CAS administrator has configured it that way.
In my case we are using Active Directory as that CAS backend and the defaults are based on that.

Attribute name in extra attributes for email address
*  plugin_cas_sso_email = UserPrincipalName

If the above is not set the plugin will set the email address to *username@YOUR.EMAIL.DOMAIN*
if plugin_cas_sso_email_domain is set. Otherwise it will be set to *username@*
*  plugin_cas_sso_email_domain = 'YOUR.EMAIL.DOMAIN'

The attribute name in extra attributes for display name. If the attribute can
not be found the username will be used instead.
*  plugin_cas_sso_name = Name

Auto approve newly created users.
*  plugin_cas_sso_user_approved = true


Support
-------
Tag me `eriko` on http://meta.discourse.org in the `support` category

