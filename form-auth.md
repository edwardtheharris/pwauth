---
abstract: This is a guide to using pwauth for authentication of web forms.
authors:
  - name: Xander Harris
    email: xandertheharris@gmail.com
date: 2025-05-14
title: Using PWAUTH with Form Authentication
---

Although `pwauth` was designed for use with the mod_auth_external Apache
module to do "Basic Authentication", it can also be "Form Authentication".

In "Form Authentication" you display a login form in HTML.

```{code-block} html
:caption: Form Authentication example

<FORM ACTION=login.cgi METHOD=post>
Login:    <INPUT TYPE=text NAME=login><BR>
Password: <INPUT TYPE=password NAME=passwd><BR>
<INPUT TYPE=submit VALUE="Login Now">
</FORM>
```

When a person submits this form, the "login.cgi" program gets run. It checks
the login and password, and if they are correct, initiates a session for
the user. See <http://unixpapa.com/auth/> for more information about this,
including explanations about why it is important for good security to use
"METHOD=post", and to turn off caching both on the login form page and on
the first page transmitted after a successful login.

It is possible to use 'pwauth' (or any other authenticator written for
mod_auth_external) with this kind of authentication system. All you have
to do is have your CGI program run 'pwauth' when it wants to check the
password.

Here's a sample function in Perl that does exactly this. It assumes that
the 'pwauth' program has been compiled with ENV*METHOD \_NOT* defined (which
is generally more secure).

```{code-block} perl
$pwauth_path= "/usr/local/libexec/pwauth";

sub trypass {
    my $userid= $_[0];
    my $passwd= $_[1];

    open PWAUTH, "|$pwauth_path" or
      die("Could not run $pwauth_path");
    print PWAUTH "$userid\n$passwd\n";
    close PWAUTH;
    return !$?;
}
```

Obviously the $pwauth_path should be defined to wherever you install pwauth,
and the die() call should be replaced with whatever is an appropriate way
to handle a fatal error in your CGI program.

Note that pwauth must be configured so that SERVER_UIDS includes whatever
uid your CGI program runs as. Normally this is the same user ID that httpd
runs as, but if your CGIs are running under suExec, then you may need to
include other uid numbers.

You may want to examine the return code from pwauth more carefully than is
done in this example, so that you can tell the user if his login was rejected
due to logins being turned off, his account being expired, or his password
being expired. Though in some configurations pwauth will return different
return codes for bad password and bad login name, it is generally considered
good practice NOT to tell the user which of these two occured.

With reasonable caution, this is as secure as using 'pwauth' with
mod_auth_external or mod_authnz_external.

```{sectionauthor} Jan Wolter <jan@unixpapa.com>

```
