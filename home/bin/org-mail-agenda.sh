#!/bin/sh

# o-m-a -- script that compiles the weekly agenda from Org-Mode and
#          mails you the output, intended to be used from cron every
#          Monday morning
#
# Copyleft (C) 2009 Adrian C. <anrxc sysphere.org>

# Sample cronjob
#   10 0 * * 1 ~/code/bash/org-mail-agenda.sh

mail="myself@example.com"
subj="cron: weekly agenda and calendar"

dir="/home/anrxc/.org/"
nail="/usr/bin/mailx"
emacs="/usr/bin/emacs"

cd $dir
$emacs -batch -eval \
 '(org-batch-agenda "a" org-agenda-ndays 7 org-agenda-include-diary nil org-agenda-files (quote ("index.org" "computers.org" "personal.org")))' \
 | $nail -E -s "$subj" $mail
