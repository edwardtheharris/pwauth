---
abstract: >-
  Installation guide for pwauth, a tool to provide unix authentication
  to web servers.
authors:
  - name: Xander Harris
    email: xandertheharris@gmail.com
title: Installation Notes for pwauth.c
---

This program is designed to be used with Apache to authenticate users out
of the password file. To use it for basic authentication, follow the
instructions below. See the [FORM_AUTH](form-auth.md) instructions
for notes on using it
with other forms of authentication.

1. Install `mod_auth_external` or `mod_authnz_external` in Apache. This
   version of pwauth requires `mod_auth_external` version 2.1.1 or later.
   You can either recompile Apache with the new modules, or install them
   as dynamically loaded modules. See the module installation instructions
   for detail.

2. Edit the {file}`pwauth/config.h` file in this directory to set the configuration
   appropriate for your system. There are lots of comments in the file.

3. If you are using PAM on Linux, you could be missing the header files
   you need to compile the {file}`auth_pam.c` file. You may need to load some
   sort of PAM development module this isn't part of the standard install
   to get these headers.

4. Edit the Makefile in this directory, setting appropriate `CC`, `LIB` and
   `LOCALFLAGS` variables.

5. Do `make` to compile the program.

   ```{code-block} shell
   make
   ```

6. If you are using PAM, you need to do some work on the configuration
   files. Depending on your operating system, you'll either need to
   create a {file}`/etc/pam.d/pwauth` file or edit the {file}`/etc/pam.conf` file.

   If you have a /etc/pam.d directory, you need to create a file named
   "pwauth" inside it. The contents of this file are going to be
   entirely different for different versions of Unix, since there is
   no standardization here. Your best bet is probably to take
   an existing file in that directory and modify it. The few
   ancient examples listed below should be taken more as examples of
   the general appearance of these things than as useful prototypes.

   To authenticate out of the Unix Shadow file under Redhat 6.x, the
   `/etc/pam.d/pwauth` file would look something like this:

   ```{code-block} text
   :caption: /etc/pam.d/pwauth

   auth       required     /lib/security/pam_pwdb.so shadow nullok
   auth       required     /lib/security/pam_nologin.so
   account    required     /lib/security/pam_pwdb.so
   ```

   Under OS X 10.4.11, the following is reported to work (possibly
   the `pam_securityserver` line should be removed):

   ```{code-block} text
   :caption: /etc/pam.d/pwauth (MacOS)

   auth       required     pam_nologin.so
   auth       sufficient   pam_securityserver.so
   auth       sufficient   pam_unix.so
   auth       required     pam_deny.so
   account    required     pam_permit.so
   ```

   If you have a {file}`/etc/pam.conf` file instead of a {file}`/etc/pam.d` directory,
   then you need to add appropriate lines to that instead. For
   Solaris 2.6, you need to add lines like this to authenticate out
   of the shadow file:

   ```{code-block} text
   pwauth  auth     required  /lib/security/pam_unix.so
   pwauth  account  required  /lib/security/pam_unix.so
   ```

   You can authenticate from a [Samba](https://samba.org) server if
   you have installed the `pam_smb`
   package (available from [samba.org](http://samba.org/samba)). On Solaris 2.6, the
   {file}`/etc/pam.conf` lines to do this would be something like:

   ```{code-block} text
   pwauth  auth    required  /lib/security/pam_smb_auth.so.1
   ```

   You may want a "nolocal" flag on that line if you are authenticating from
   a remote server, or you may not. Note that if you configure pam_smb so
   that root access isn't required, you should be able to use mod_auth_pam
   instead of mod_auth_external and pwauth and get faster authentications.

7. Test the pwauth program. As root, you can just run the thing, type
   in a login (hit return) and a password (hit return), and then check
   the exit code (in csh: "echo $status" in sh: "echo $?"). It should
   be 0 for correct login/password pairs and 1 otherwise.

8. Install it in some sensible place (say, {file}`/usr/local/libexec/pwauth`).
   Unless you are doing SHADOW_NONE, it should be suid-root, so that
   it has the necessary access to read the shadow file. That is, the
   file should be owned by root, and you should do "chmod u+s pwauth" on
   it. After you've installed it, it is worth su-ing to whatever account
   your httpd runs under and testing pwauth again from that account. This
   should confirm that all the uid's and suid-bits are configured correctly.

   On OpenBSD the master password database is readable (but not writable)
   to group \_shadow, so you should be able to install it sgid to group
   "\_shadow" instead of suid root. However, I've not been able to make
   this work.

9. If you are using pwauth with mod_auth_external, add to the Apache
   server configuration file directives that give the full path to
   wherever you installed this program and designate the pipe method
   for communicating with the authenticator. For example:

   ```{code-block} aconf
   AddExternalAuth pwauth /usr/local/libexec/pwauth
   SetExternalAuthMethod pwauth pipe
   ```

   It is possible to use this module with the "environment" method
   instead of the "pipe" method by compiling it with the ENV_METHOD
   flag defined, however this has security problems on some Unixes.

10. Put an .htaccess file in whatever directory you want to protect.
    (For .htaccess files to work, you may need to change some
    "AllowOverride None" directives in your httpd.conf file into
    "AllowOverride AuthConfig" directives).

    A typical .htaccess file using mod_auth_external would look like:

    ```{code-block} aconf
     AuthType Basic
     AuthName Your-Site-Name
     AuthExternal pwauth
     require valid-user
    ```

    A typical .htaccess file using mod_authnz_external would look like:

    ```{code-block} aconf
         AuthType Basic
         AuthName Your-Site-Name
         AuthBasicProvider external
         AuthExternal pwauth
         require valid-user
    ```

    Alternately, you can put a `<Directory>` block with the same directives
    in your httpd.conf file.

11. Test it by trying to access a file in the protected directory with your
    web browser.

    1. If it fails to accept correct logins, then check Apache's error log file.
       This should give some messages explaining why authentication failed.

    2. If it was unable to execute pwauth, check that the pathnames and
       permissions are all correct.

    3. If it says that pwauth failed, it will give the numeric return code.
       The numeric return codes returned by pwauth are as follows:

       ```{code-block} text
           0  -  Login OK.
           1  -  Nonexistant login or (for some configurations) incorrect
             password.
           2  -  Incorrect password (for some configurations).

       3 - Uid number is below MIN_UNIX_UID value configured in config.h.

       4 - Login ID has expired.

       5 - Login's password has expired.

       6 - Logins to system have been turned off (usually by /etc/nologin
       file).

       7 - Limit on number of bad logins exceeded.

           50 -  pwauth was not run with real uid not in the SERVER_UIDS list.
             If you get this error code, you probably have SERVER_UIDS set
             incorrectly in pwauth's config.h file.

           51 -  pwauth was not given a login & password to check.  The means
                 the passing of data from mod_auth_external to pwauth is messed
                 up.  Most likely one is trying to pass data via environment
                 variables, while the other is trying to pass data via a pipe.

           52 -  one of several possible internal errors occured.  You'll have
             to read the source code to figure these out.

       53 - pwauth was not able to read the password database. Usually
       this means it is not running as root. (PAM and login.conf
       configurations will return 1 in this case.)
       ```

If you want to allow users of only certain groups to login, the perl
"unixgroup" command included in this directory will do the job, though not
very efficiently. If you are using mod_authnz_external, a better approach
is to use mod_authz_unixgroup. This will not only allow you to restrict
logins to users in particular groups, but restrict access to individual
files based on group ownership of the files, if used with the standard Apache
module mod_authz_owner.

```{sectionauthor} Jan Wolter <jan@unixpapa.com>

```
