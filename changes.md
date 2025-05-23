---
abstract: This is the documentation index for pwauth.
authors:
  - name: Jan Wolter
    email: jan@unixpapa.com
  - name: Xander Harris
    email: xandertheharris@gmail.com
date: 2025-05-14
title: pwauth Change Log
---

## v2.3.12

- TBD
  - Clean up the documentation.
  - Make the thing build on ArchLinux.

## [v2.3.11](https://github.com/edwardtheharris/pwauth/releases/tag/v2.3.11)

- Aug 1, 2018
  - Don't define "uid" variable if SERVER_UID is not defined.
  - Removed old-style strchr prototype.
  - Clarified some instructions in config.h.

## [v2.3.10](https://github.com/edwardtheharris/pwauth/releases/tag/v2.3.10)

- Oct 5, 2011
  - Changed the serialized sleep code in snooze.c to use fcntl() locking
    instead of flock() locking. Fcntl() locking is a POSIX standard and
    is likely to work better on more systems, notably including Solaris
    which doesn't seem to support flock() at all any more.
  - Minor fixes to typos in various documentation.

## [v2.3.9](https://github.com/edwardtheharris/pwauth/releases/tag/v2.3.9)

- May 2, 2011
  - Add AUTHENTICATE_AIX option for authenticating via AIX's authentication
    configuration system. Thanks to Hans Dieter Petersen of the University
    of Bonn for this implementation.
  - Renamed PAM_OS_X configuration setting to PAM_OLD_OS_X since it only
    is needed for OS X 10.5 and older.
  - Rearranged ifdef's so that undefining SLEEP_LOCK actually completely
    disables the sleep-on-failure behavior.
  - Minor documentation fixes

## [v2.3.8](https://github.com/edwardtheharris/pwauth/releases/tag/v2.3.8)

- Apr 3, 2009
  - Clearing `SERVER_UIDS` now disables the runtime `uid` check. Documentation
    added to suggest using this, together with group execution permissions on
    the binary, to create a group for users who can run `pwauth`. Thanks to
    [Adi Kriegisch](adi@kriegisch.at) for suggesting this.
  - Return a distinct status code if authentication fails because we are not
    running as root. This is currently only done for SHADOW_SUN, SHADOW_BSD,
    SHADOW_AIX, and SHADOW_MDW. It's just to help confused installers
    figure out why things aren't working.
  - Warn installers that they may need to install PAM development packages.

## VERSION 2.3.7

- Jan 9, 2009 (2009-01-09)
  - DOCUMENTATION FIX ONLY
  - Corrected erroneous `AuthBasicProvider` command in [install](install.md) file.

## VERSION 2.3.6

- May 19, 2008
  - Add PAM_OS_X option.
  - Clarified comments in {file}`pwauth/config.h`.
  - Replace wildly obsolete inclusion of strings.h with inclusion of string.h

## VERSION 2.3.5

- Dec 17, 2007
  - Fixed return codes from AIX and HPUX versions (thanks to Paul Marvin for
    finding this bug).

## VERSION 2.3.4

- Nov 11, 2007
  - Fixed PAM_SOLARIS define.

## VERSION 2.3.3

- Sep 1, 2007
  - Don't allow logins during inactive period after password expiration.

## VERSION 2.3.2

- Feb 19, 2006
  - Update documentation to discuss usage with mod_authnz_external.
  - Update documentation to discuss use of mod_authz_unixgroup instead of the
    unixgroup script.
  - Drop "development release" notation.

## VERSION 2.3.1

- Jan 10, 2005
  - Fix the checks for expired passwords and expired accounts for
    LOGIN_CONF_OPENBSD configurations.
  - Fix the handling of the pam_message argument to the conversation function
    for Solaris. The old handling was right for Linux PAM and OpenPAM, but
    not for Solaris. However, the bug occurs only when the PAM modules passes
    more than one prompt to the conversation function, which should probably
    never happen.

## VERSION 2.3.0

- Sep 28, 2004
  - Status code values returned by pwauth have changed. 0 is still success,
    of course, but there is a much wider range of non-zero error codes returned
    to indicate different causes of login failure.
  - Pwauth now checks for /etc/nologin file by default. Undefine
    NOLOGIN_FILE in config.h if you don't want this behavior.
  - Pwauth now checks if an account is expired and refuses logins if it is.
    Undefine CHECK_LOGIN_EXPIRATION in config.h if you don't want this
    behavior.
  - Pwauth now checks if an account's password has expired and refuses logins
    if it is and if logins are supposed to be disabled when the password has
    expired. Undefine CHECK_PASSWORD_EXPIRATION if you don't want this
    behavior.
  - Added support for authenticating through login.conf interface on OpenBSD.
    Support for login.conf systems on other versions of Unix is not yet here.
  - Added support for OpenBSD failure logs.
  - Source code split into multiple files.
  - Added 'checkfaillog' program which CGIs can run to report/reset failures
    and admins can run to reset failure counts.

## VERSION 2.2.8

- Sep 25, 2004
  - First separate distribution of pwauth. This version is identical to
    the version in the mod_auth_external version 2.2.8 package, except for
    repackaging and slight modifications to the documentation.

```{note}
Versions of pwauth previous to version 2.2.8 were distributed as part of
the mod_auth_external package, and change-log information is included in
pwauth change log.
```
