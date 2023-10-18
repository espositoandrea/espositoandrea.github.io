---
layout: post
author: Andrea Esposito
title: "Old Software Revival: Roff and Text Processing"
subtitle: "Troff and its friends: still useful in 2021?"
image: /assets/images/banners/roff.png
lang: en
categories: [software]
tags: [software, unix]
excerpt: >-
  When the UNIX operating system was released by AT&T, one of its requirements was a text processing and document preparation software. The implementation of such module was delegated to the software named "roff".
---

# Introduction

When the UNIX operating system was released by AT&T, one of its requirements was a text processing and document preparation software \[1\]. The implementation of such module was delegated to the software named "roff" using its two implementations "troff" (for typesetting output) and "nroff" (for terminals and line-based printers) \[2\]. Although this software suite is old and outdated, it is still in use today: most Unix-based software (meaning [Linux](https://linux.org), [OpenBSD](https://www.openbsd.org), and even [MacOS](https://www.apple.com/it/macos/)) still use a modified version of roff (known as "groff", from "GNU troff", implemented by GNU \[3\]) to display what it is known as “man pages”, i.e. manuals for command-line tools.

Since it is still in use today, even if for a rather specific task, it is still worth it to know how it works and how it can be used: it can also be used, in fact, to quickly typeset a document without having the need of downloading heavy software like LaTeX or an Office suite. The roff language is rather low-level, so to keep it simple this article will provide a guide using the default “macro packages”, that are similar to libraries or modules in programming languages: they provide useful commands that are predefined using the basic commands of the language \[4\].

The troff/nroff commands are single-pass: they take the text and directly typeset it without any need for long compilation times and multiple compilations to get the references right. Actually, in the "basic" roff language there is no concept of "references": as with all UNIX tools, roff does one thing and does it well. It is designed to be used in conjunction with other tools, usually referred to as "roff's friends", that are responsible for the execution of a task related to the typesetting of a document. For example, the PIC preprocessor is used to draw diagrams using a simpler interface than the default roff one; the EQN preprocessor is used to typeset equations; the "refer" preprocessor is used to manage bibliographies; etc.

This article should not be considered a guide to the usage of roff and its derivates, but rather a simple notification that something like it exists. If it fits your interests, I'll provide a series of tutorials on the basics of the roff language and its "friends", i.e. other tools to be used with it (like the PIC and EQN preprocessors).

# Why Should I Use Roff?

Being a very old software, it may seem useless to spend some time to understand how it works and to actually learn how to use it. But knowing it has its benefits. First thing first, although old, it is still in use: manual pages are (as already said) written using the roff language by the means of either the `man` or `mdoc` macro packages. Furthermore, between developers it's common to have to use a terminal to navigate, for example, the file system of a server: imagine to have your server-side components' documentation right there, viewable from both the terminal and in PDF form both compiled on-demand from the same source. Finally, roff documents are simple text files: even a century from now, you'll always be able to open the document and read it even without the need of compiling it and, if you need to have it in PDF form, groff is free software, so you'll be able to download its source code and compile it on your future OS.

# Some Examples

In the following subsections, I'll present two very basic examples of usage of the `ms` and `man` macro packages.

## The MS Macro Package

The best way to learn any kind of language, in any kind of context, is probably by using examples. The following is a simple document written using the "ms" macro package:

```plaintext
.TL
A Simple Paper Example
.AU
Andrea Esposito
.AI
Author Institution
Italy
.NH 1
A heading
.PP
This is some running text.
.NH 2
A sub-heading
.PP
Some more text.
```

That can be easily compiled into a PDF using the following command:

```sh
groff -ms -Tpdf FILENAME > FILENAME.pdf
```

Obtaining the following results:

![Example of Roff MS macros in PDF](https://cdn.hashnode.com/res/hashnode/image/upload/v1628786196455/lZopkc9BZ.png align="left")

Or it can be viewed directly inside the terminal using the following command:

```sh
groff -ms -Tutf8 FILENAME | less -R
```

Obtaining the following results:

![Example of Roff MS macros in a Terminal](https://cdn.hashnode.com/res/hashnode/image/upload/v1628786132228/TAgWHJNDc.png align="left")

## The MAN Macro Package

The following is a simple document written using the "man" macro package. Note that usually man pages have a predefined structure that should be respected: you can read about it by reading [this man page](https://linux.die.net/man/7/man-pages).

```plaintext
.TH "EXAMPLE" 1
.SH "An Heading"
.PP
This is a simple paragraph.
.SH "Another Heading"
.PP
This is a simple paragraph.
.SS "A Sub-Heading"
.PP
Yet another paragraph.
```

That can be easily compiled into a PDF using the following command:

```sh
groff -man -Tpdf FILENAME > FILENAME.pdf
# Or (it may not work on some implementations of the man command):
man -Tpdf -l FILENAME > FILENAME.pdf
```

Obtaining the following results:

![Example of Roff MAN macros in PDF](https://cdn.hashnode.com/res/hashnode/image/upload/v1628787136014/YOgRFDIg0.png align="left")

Or it can be viewed directly inside the terminal using the following command:

```sh
groff -man -Tutf8 FILENAME | less -R
# Or (it may not work on some implementations of the man command):
man -l FILENAME
```

Obtaining the following results:

![Example of Roff MAN macros in a Terminal](https://cdn.hashnode.com/res/hashnode/image/upload/v1628787213088/Jvy6AOZKL.png align="left")

# References

1. D. M. Ritchie and K. L. Thompson, "The UNIX Time-Sharing System," Bell System Technical Journal, vol. 57, pp. 1905-1929, 1978.
    
2. B. W. Kernighan, M. E. Lesk, and J. F. Ossanna, "UNIX time-sharing system: Document preparation," The Bell System Technical Journal, vol. 57, no. 6, pp. 2115-2135, 1978.
    
3. wl, ps and bg, "GNU troff (groff) — a GNU project," GNU, 28 12 2018. \[Online\]. Available: https://www.gnu.org/software/groff/. \[Accessed 12 08 2021\].
    
4. D. Dougherty and T. O'Reilly, Unix Text Processing, Indianapolis, Indiana: Hayden Books, 1987.
