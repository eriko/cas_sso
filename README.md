cas_sso
=======
CAS based single sign on for Discourse in plugin form.


Installation
------------

* Run `rake plugin:install repo=https://github.com/eriko/cas_sso` in your discourse directory
* In development mode, run `rake assets:clean`
* In production, recompile your assets: `rake assets:precompile`

Until the omniauth-cas gem that supports dynamic setup is released (it should be soon) the plugin uses
a forked version that I maintain.

The initial restart maybe a little slower than usual as the plugin also installs any plugins that it needs.
In this case that is `addressable` and my forked `eriko-omniauth-cas`.  This slow down should be a one
time event unless the plugin is updated.


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

`cas_sso_email:
     default:  'UserPrincipalName'`

If the above is not set the plugin will set the email address to *username@YOUR.EMAIL.DOMAIN*
if plugin_cas_sso_email_domain is set. Otherwise it will be set to *username@*

`cas_sso_email_domain:
     default:  'YOUR.EMAIL.DOMAIN'`

The attribute name in extra attributes for display name. If the attribute can
not be found the username will be used instead.

`cas_sso_name:
     default: 'Name'`

Auto create newly logged in CAS users (reject new users that do not have accounts already)

`cas_sso_user_auto_create:
     default:  true`

Auto approve newly created users.

`cas_sso_user_approved:
     default:  true `

Limit the auto creation of accounts by group membership in the optional Groups extension of CAS.  This will
need to be turned on by you CAS administrator.  The default groups are based on LDAP paths but this may be different for
your organization. Once again talk to your CAS administrator.  If the user is in a group that is in the allow list they are
eligible to have an account created.  If on the other hand they they have a group that is in the deny list they will not
and account created.  This data is processed by turning the two lists into Sets and then looking for an intersection.  The
groups coming from CAS are split(', ') and this may be particular to Jasig CAS in combination with AD. The deny overrides the allow.

If it does not work for your instance let me know, preferably with a sample of the groups data. Search for #DEBUGGING
in pluging.rb to enable dumping of the groups data. You will need restart the app after it is uncommented.  You
should disable this when you are done.

`cas_sso_groups_allow_filter:
    default:  false`
`cas_sso_groups_allow:
      client: true
      type: list
      default: 'CN=staff,OU=Groups,DC=example,DC=edu|CN=students,OU=Groups,DC=example,DC=edu|CN=faculty,OU=Groups,DC=example,DC=edu' `
`cas_sso_groups_deny_filter:
    default:  false`
`cas_sso_groups_deny:
      client: true
      type: list
      default: 'CN=staff,OU=Groups,DC=example,DC=edu|CN=students,OU=Groups,DC=example,DC=edu|CN=faculty,OU=Groups,DC=example,DC=edu' `



CSS override of button text
---------------------------
If you like me only have one auth method activated and want to change the text in the little green button you can.
Add at stylesheet customization like the one below.

  `.btn-social.cas:before {
     content: "YOUR LOGIN WORD HERE";
     font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
  }`

  `.btn-social:before {
  margin-right: 5px;
  }`


Support
-------
Tag me `eriko` on http://meta.discourse.org in the `support` category

