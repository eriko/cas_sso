cas_sso
=======

CAS based single sign on for Discourse in plugin form.

Required settings
-----------------
Full uri for your CAS server.  Some servers are use a trailing */cas* and some do not.
*  plugin_cas_sso_url = 'https://YOUR.CAS.SERVER/cas'

Optional settings
-----------------

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

