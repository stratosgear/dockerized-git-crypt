## Dockerized git-crypt Alpine image

[Git-crypt](https://github.com/AGWA/git-crypt) in docker.

This was build after frustration in getting `git-crypt` installed in my arch installation, after keep failing with openssl compilation errors.


## Installation

Clone the repo locally and cd to it.

Check if you want to change the `uid` and `gid` in the `Dockerfile` to your own (so files created by `git-crypt` will be owned by you and **not** *root*) and build the image:

```
$ docker build -t [some_name] .
```

Create a shell wrapper **git-crypt** as **/usr/local/bin/git-crypt** (hopefully this path is in your $PATH):

```
#!/bin/bash -e
exec docker run -i -v $PWD:/repo [some_name] "$@"
```


## Usage

**NOTE**: To be honest this hack has problems adding and using gpg users, that I didn't have time debugging.  In my use case, using symmetric keys, it is working fine though:


```
$ mkdir test-repo

$ cd test-repo/

$ git init
Initialized empty Git repository in /mnt/data/projects/sources/test-repo/.git

 master $ git-crypt init
Generating key...

 master $ echo "secret.txt filter=git-crypt diff=git-crypt" > .gitattributes

 master … $ ls -al
total 16
drwxr-xr-x  3 stratos stratos 4096 Apr 28 00:40 ./
drwxr-xr-x 14 stratos stratos 4096 Apr 28 00:38 ../
drwxr-xr-x  8 stratos stratos 4096 Apr 28 00:38 .git/
-rw-r--r--  1 stratos stratos   43 Apr 28 00:40 .gitattributes

 master … $ git add .gitattributes

 master ~ $ git commit -m "Inited repo"
[master (root-commit) bf2475b] Inited repo
 1 file changed, 1 insertion(+)
 create mode 100644 .gitattributes$  master

 master $ echo "The password is: 12345678" > secret.txt

 master … $ git-crypt status
    encrypted: secret.txt
not encrypted: .gitattributes

 master … $ git add secret.txt

 master ~ $ git commit -m "Added secret file"
[master aba3e87] Added secret file
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 secret.txt

 master $ git-crypt export-key testing_export.key

 master … $ ls -al
total 24
drwxr-xr-x  3 stratos stratos 4096 Apr 28 00:43 ./
drwxr-xr-x 14 stratos stratos 4096 Apr 28 00:38 ../
drwxr-xr-x  9 stratos stratos 4096 Apr 28 00:42 .git/
-rw-r--r--  1 stratos stratos   43 Apr 28 00:40 .gitattributes
-rw-r--r--  1 stratos stratos   26 Apr 28 00:41 secret.txt
-rw-------  1 stratos stratos  148 Apr 28 00:43 testing_export.key

```
