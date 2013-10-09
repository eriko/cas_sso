cas_sso
=======

CAS based single sign on for Discourse in plugin form.

Required settings
-----------------
Full uri for your CAS server.  Some servers are use a trailing */cas* and some do not.
*  CAS_URL = 'https://YOUR.CAS.SERVER/cas'

Optional settings
-----------------

Attribute name in extra attributes for email address
*  EMAIL = :UserPrincipalName

If the above is not set the plugin will set the email address to *username@CAS_EMAIL_DOMAIN*
if CAS_EMAIL_DOMAIN is set. Otherwise it will be set to *username@*
*  CAS_EMAIL_DOMAIN = 'YOU.EMAIL.DOMAIN'

The attribute name in extra attributes for display name. If the attribute can
not be found the username will be used instead.
*  NAME = :Name

Auto approve newly created users.
*  APPROVED = true
