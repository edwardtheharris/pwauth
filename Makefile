# The following three lines should be modified to appropriate values for your
# system.  Most of the configurable stuff is in config.h
#
#   CC=       an ansi-C compiler.  If "cc" doesn't work, try "gcc".
#   LIB=      libraries to link in.  -lcrypt, -lshadow, -lpam sometimes needed.
#   LOCALFLAGS=   compiler flags.  Usually -g, -O, and stuff like that.

# Settings for author's system (Redhat 6.1)
CC=gcc
LIB= -lcrypt
LOCALFLAGS= -g

# For PAM on Redhat Linux
# LIB=-lpam -ldl

# For PAM on Solaris or OS X
# LIB=-lpam

# -------------------- No User Servicable Parts Below -----------------------

TAR= readme.md install.md changes.md form-auth.md Makefile pwauth/main.c pwauth/checkfaillog.c \
	pwauth/fail_check.c pwauth/fail_log.c pwauth/lastlog.c pwauth/nologin.c pwauth/snooze.c pwauth/auth_aix.c \
	pwauth/auth_bsd.c pwauth/auth_hpux.c pwauth/auth_mdw.c pwauth/auth_openbsd.c pwauth/auth_pam.c \
	pwauth/auth_sun.c pwauth/config.h pwauth/fail_log.h pwauth/pwauth.h pwauth/unixgroup

.PHONY: clean distclean

CFLAGS= $(LOCALFLAGS)

pwauth/pwauth: pwauth/main.o pwauth/auth_aix.o pwauth/auth_bsd.o pwauth/auth_hpux.o pwauth/auth_mdw.o pwauth/auth_openbsd.o \
	pwauth/auth_pam.o pwauth/auth_sun.o pwauth/fail_log.o pwauth/lastlog.o pwauth/nologin.o pwauth/snooze.o
	$(CC) -o pwauth $(CFLAGS) $(LDFLAGS) pwauth/main.o pwauth/auth_aix.o pwauth/auth_bsd.o \
		pwauth/auth_hpux.o pwauth/auth_mdw.o pwauth/auth_openbsd.o pwauth/auth_pam.o pwauth/auth_sun.o \
		pwauth/fail_log.o pwauth/lastlog.o pwauth/nologin.o pwauth/snooze.o $(LIB)

checkfaillog: checkfaillog.o fail_check.o
	$(CC) -o checkfaillog $(CFLAGS) $(LDFLAGS) checkfaillog.o \
		fail_check.o $(LIB)

main.o: pwauth/main.c pwauth/config.h pwauth/pwauth.h pwauth/fail_log.h
auth_aix.o: auth_aix.c config.h pwauth.h
auth_bsd.o: auth_bsd.c config.h pwauth.h
auth_hpux.o: auth_hpux.c config.h pwauth.h
auth_mdw.o: auth_mdw.c config.h pwauth.h
auth_openbsd.o: auth_openbsd.c config.h
auth_pam.o: auth_pam.c config.h pwauth.h
auth_sun.o: auth_sun.c config.h pwauth.h
checkfaillog.o: checkfaillog.c config.h fail_log.h
fail_check.o: fail_check.c config.h fail_log.h
fail_log.o: fail_log.c config.h pwauth.h fail_log.h
lastlog.o: lastlog.c config.h pwauth.h
nologin.o: nologin.c config.h pwauth.h
snooze.o: snooze.c config.h pwauth.h


clean:
	rm -f *.o

distclean:
	rm -f *.o pwauth checkfaillog

pwauth.tar: $(TAR)
	tar cvf pwauth.tar $(TAR)
