cas_sso
=======

CAS based single sign on for Discourse in plugin form.

Required settings
  CAS_URL = 'https://YOUR.CAS.SERVER/cas'

Optional settings

  #attribute name in extra attributes for email address
  EMAIL = :UserPrincipalName
  #if the above is not set the plugin will set the
  #email address to username@CAS_EMAIL_DOMAIN if CAS_EMAIL_DOMAIN is set.
  #otherwise it will be set to username@
  CAS_EMAIL_DOMAIN = 'YOU.EMAIL.DOMAIN'

  #The attribute name in extra attributes for display name.
  #If the attribute can not be found the username will be used instead.
  NAME = :Name