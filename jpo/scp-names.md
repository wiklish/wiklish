---
title: scp(1) mangles file names!
layout: wikipage
---
Due to its overly simplistic design, [scp(1)](http://man.openbsd.org/OpenBSD-current/man1/scp.1) will mangle filenames with newlines ('\n', 0x0a) in them.
This is because the "scp protocol" (which does not appear to be properly documented anywhere afaict -- closest thing is probably this [blog post](https://blogs.oracle.com/janp/entry/how_the_scp_protocol_work)) uses newlines to denote the end of a filename, and expects the actual data of the file to follow immediately after.

Prior to [this commit in 2007](http://cvsweb.openbsd.org/cgi-bin/cvsweb/src/usr.bin/ssh/scp.c.diff?r1=1.157&r2=1.158&f=h) scp would just skip files with newlines in them.

The relevant code can be found in [src/usr.bin/ssh/scp.c](http://cvsweb.openbsd.org/cgi-bin/cvsweb/~checkout~/src/usr.bin/ssh/scp.c):

```
void
source(int argc, char **argv)
{
	...
		if (strchr(name, '\n') != NULL) {
			strnvis(encname, name, sizeof(encname), VIS_NL);
			name = encname;
		}

```

which causes:

% uname -a
Linux x1 4.4.0-22-generic #40-Ubuntu SMP Thu May 12 22:03:46 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
% ssh -V
OpenSSH_7.2p2 Ubuntu-4ubuntu1, OpenSSL 1.0.2g-fips  1 Mar 2016
% touch a$'\n'b
% touch 'c\^Jd'
% stat -c'<<<%n>>>' *
<<<a
b>>>
<<<c\^Jd>>>
% ls
a?b  c\^Jd
% ls -al
total 24
drwxrwxr-x  2 jpo  jpo   4096 Jun  3 02:35 .
drwxrwxrwt 18 root root 20480 Jun  3 02:17 ..
-rw-rw-r--  1 jpo  jpo      0 Jun  3 02:05 a?b
-rw-rw-r--  1 jpo  jpo      0 Jun  3 02:11 c\^Jd
% tree
.
├── a\012b
└── c\^Jd

0 directories, 2 files
% find .
.
./a?b
./c\^Jd
% scp -r . dev:/tmp/x  
a\^Jb                                     100%    0     0.0KB/s   00:00    
c\^Jd                                     100%    0     0.0KB/s   00:00    
% ssh dev
dev% uname -a
OpenBSD dev.jpo.me 6.0 GENERIC.MP#2161 amd64
dev% ssh -V
OpenSSH_7.2, LibreSSL 2.4.0
dev% cd /tmp/x
dev% touch e$'\n'f
dev% find .       
.
./a\^Jb
./c\^Jd
./e
f
dev% ls -al
total 8
drwxrwxr-x  2 jpo   wheel  512 Jun  3 02:37 .
drwxrwxrwt  8 root  wheel  512 Jun  3 02:21 ..
-rw-r--r--  1 jpo   wheel    0 Jun  3 02:20 a\^Jb
-rw-r--r--  1 jpo   wheel    0 Jun  3 02:20 c\^Jd
-rw-r--r--  1 jpo   wheel    0 Jun  3 02:23 e?f
dev% stat -f'<<<%N>>>' *
<<<a\^Jb>>>
<<<c\^Jd>>>
<<<e
f>>>
```
