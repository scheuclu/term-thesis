![AM-LaTeX-Logo](info/source/gitlab-welcome-logo.png)

[![build status](https://gitlab.lrz.de/AM/AMlatex/badges/master/build.svg)](https://gitlab.lrz.de/AM/AMlatex/commits/master)
[![version 2.2](https://img.shields.io/badge/version-2.2-dad7cb.svg?style=flat)](https://gitlab.lrz.de/AM/AMlatex/tags#stable-release-version-22)

Overview:
---------
1. [Use of GitLab](#1-use-of-gitlab)
2. [Installation instructions](#2-installation-instructions)
3. [User guides and templates](#3-user-guides-and-templates)
4. [Tutorials](#4-tutorials)
5. [Common problems](#5-common-problems)
6. [Repository structure](#6-repository-structure)

1. Use of Gitlab
================
The main goal of this project is to provide for the members of the department 
applied mechanics (AM) common LaTeX-based packages, classes and templates.

It also aims at gathering the documentation on latex and offers help support:
encountered problem with AMlatex should be reported here. 

As a consequence __students are invited to create an [issue][user create issue]__ 
whenever they have difficulties using the provided templates. 
This [wiki page][wiki support info] describes the information you should provide
when asking for support.

2. Installation instructions
============================

**Warning:** the following instructions install only the templates and classes,
that are used at the Applied Mechanics department of the TUM. Make sure a 
working latex distribution is installed on your computer *before*. 
[Help](https://gitlab.lrz.de/AM/AMlatex/wikis/how-to-install-latex)


### Automatic installation (recommended, all platforms)

Note that you will have to download [Git Bash][git bash download] first if you 
are using Microsoft Windows.

1. Download the last release [here][amlatex download page].
   *Note:* the link you have to click will be in the release description: please
   do **not** download the zip file from the *source code* button.
2. Extract the downloaded archive file AMlatex-vX.X.zip
3. Open a terminal and go in the extracted directory AMlatex/.
4. Run `./setup.sh install` 

Visit this [wiki page][wiki install amlatex] for additional details or 
[alternative installation methods][wiki install amlatex alter].

3. User guides and templates
============================

Available classes
-----------------

|               |                     |              |                     |                    |
| ------------- | ------------------- | ------------ | ------------------- | ------------------ |
| [AMaushang][] | [AMbeamer][]        | [AMbrief][]  | [AMdocument][]      | [AMdissertation][] |
| [AMexam][]    | [AMstudentThesis][] | [AMposter][] | [AMlectureScript][] |                    |


Available packages
------------------

|              |              |              |               |                 |              |
| ------------ | ------------ | ------------ | ------------- | --------------- | ------------ |
| [AMbiblio][] | [AMcolor][]  | [AMfont][]   | [AMgraphic][] | [AMlang][]      | [AMlayout][] |
| [AMlogo][]   | [AMmath][]   | [AMref][]    | [AMtikz][]    | [AMtitlepage][] | [AMutils][]  |



4. Tutorials
============

Visit our [Wiki on LaTeX](https://gitlab.lrz.de/AM/AMlatex/wikis/home)

[![AM-LaTeX-Wiki-Logo](info/source/AMlatex-wiki-logo.png)](https://gitlab.lrz.de/AM/AMlatex/wikis/home)

5. Common problems
==================

| Error              | Solution                                               |
| ------------------ | ------------------------------------------------------ |
| Adobe Reader: "There was a problem reading this document (131)" | Enter `\pdfminorversion=4` at the very beginning of your tex file. |
| MiKTeX: "miktex-makepk: PK font t1-stixgeneral could not be created" | Open command (cmd.exe) as administrator and enter `initexmf --mkmaps` |
| TeXstudio: "Package tikz Error: Sorry, the system call 'pdflatex -halt-on-error..." | Make sure that `-shell-escape` is given as option for pdflatex in the texstudio settings |

6. Repository structure
=======================
At the center of the project stand the dtx files (for Documented LaTeX sources).
Those files are the sources of both the code and its documentation. 
This project contains also an extraction program responsible for transformation 
of the dtx-files into sty-, cls- and pdf-files.

* [apps](apps) _(programs, application and scripts)_
    + [updater](apps/updater)
    + [githooks](apps/githooks)
    + [setup](apps/setup)
* [info](info) _(guides and turorials, with their sources)_
    + [guides](info/guides)
    + [source](info/source)
* [templates](templates) _(examples of use)_
    + [Dissertation](templates/Dissertation)
    + [abstract](templates/abstract)
    + [thesis](templates/thesis)
    + [poster](templates/poster)
    + ...
* [texmf](texmf) _(standard tex directory with the packages and classes)_
    + [fonts](texmf/fonts)
    + [source](texmf/source)
        - [skeleton_class.dtx](texmf/source/skeleton_class.dtx)
        - [skeleton_package.dtx](texmf/source/skeleton_package.dtx)
        - [latex/AM](texmf/source/latex/AM) _(contains the dtx files)_
    + [tex/latex](texmf/source/tex/latex)
        - [resources](texmf/source/tex/latex/resources)
        - [tum](texmf/source/tex/latex/tum)


[user create issue]: https://gitlab.lrz.de/AM/AMlatex/issues/new?issue[assignee_id]=&issue[milestone_id]=
[wiki support info]: https://gitlab.lrz.de/AM/AMlatex/wikis/support-information
[wiki install amlatex]: https://gitlab.lrz.de/AM/AMlatex/wikis/how-to-install-amlatex
[wiki install amlatex alter]: https://gitlab.lrz.de/AM/AMlatex/wikis/how-to-install-amlatex
[git bash download]: https://git-scm.com/download/win
[amlatex download page]: https://gitlab.lrz.de/AM/AMlatex/tags
[AMaushang]: https://syncandshare.lrz.de/dl/fiBr4K19bW8JfbKYHXyKHY4B/AMaushang.pdf
[AMbeamer]: https://syncandshare.lrz.de/dl/fiBVRQXWzoZjvdqQiHHMPs7h/AMbeamer.pdf
[AMbrief]: https://syncandshare.lrz.de/dl/fiTWZdXMAbX6LgQp2YV8R1vh/AMbrief.pdf
[AMdocument]: https://syncandshare.lrz.de/dl/fiMHTsbnWdcPGNi7FGuCxinf/AMdocument.pdf
[AMdissertation]: https://syncandshare.lrz.de/dl/fi5Uc8y1JgLB2xXd3RPcyS8y/AMdissertation.pdf
[AMexam]: https://syncandshare.lrz.de/dl/fiNBNXTqGaB1BoMjJnuknfRp/AMexam.pdf
[AMstudentThesis]: https://syncandshare.lrz.de/dl/fiANepiMFUL7NyjzN5bqGWde/AMstudentThesis.pdf
[AMposter]: https://syncandshare.lrz.de/dl/fiFszAcmCwtSSMExvzMnvyWy/AMposter.pdf
[AMlectureScript]: https://syncandshare.lrz.de/dl/fiG6o6iERNUvDdgqMW5oTeMo/AMlectureScript.pdf
[AMbiblio]: https://syncandshare.lrz.de/dl/fiVtgKtTVFunvdpBSMQHDdU3/AMbiblio.pdf
[AMcolor]: https://syncandshare.lrz.de/dl/fiN3W1ziyVnZxf3r5C3PAAs/AMcolor.pdf
[AMfont]: https://syncandshare.lrz.de/dl/fiCS1xwzDwa7je7t3Yghp9iJ/AMfont.pdf
[AMgraphic]: https://syncandshare.lrz.de/dl/fiVaJLVAuZdxLhJ1e9nzwpUh/AMgraphic.pdf
[AMlang]: https://syncandshare.lrz.de/dl/fiJPtra8N4hgfQfPYtMuPiPu/AMlang.pdf
[AMlayout]: https://syncandshare.lrz.de/dl/fi3WoKvV6NiDgGggp9eBKahp/AMlayout.pdf
[AMlogo]: https://syncandshare.lrz.de/dl/fiM7JM5eABz9yuyPQzo21bPt/AMlogo.pdf
[AMmath]: https://syncandshare.lrz.de/dl/fi4eAsx7gmbMec119NDhjCVy/AMmath.pdf
[AMref]: https://syncandshare.lrz.de/dl/fiMyCz5yxUGiTba5DbmEtt3/AMref.pdf
[AMtikz]: https://syncandshare.lrz.de/dl/fi9aPAgHXBDzQ9CkZ7gCDm8F/AMtikz.pdf
[AMtitlepage]: https://syncandshare.lrz.de/dl/fiUXiu52P2SGYwamh8WDttfK/AMtitlepage.pdf
[AMutils]: https://syncandshare.lrz.de/dl/fiJaTeZ3EqTXkNrZtycXjUhP/AMutils.pdf
