---
title: We Installed Arch, BTW
date: 2021-11-03
author: Tom Faughnan
---

Of all the Linux distributions out there, perhaps none is more memed than [Arch Linux].
Arch is billed as a lightweight and customizable distro that tries to abide by the
[KISS] philosophy.[^1] Some of its most compelling offerings are the high quality [wiki],
which is applicable for users of every distro, and the [AUR], a large collection of
build scripts for software outside the official package repositories.

Installation of Arch is sometimes considered difficult, because it requires more involvment
from the user than other distros. But in reality, anyone can install it by following the
well-written [installation guide]. Our club decided to install it together in order to learn
more about the steps of the process that more traditional installers do on the user's behalf. 

We used [Quickemu], a wrapper around [QEMU], to easily spin up a virtual machine for an Arch
install. Then we proceeded through the installation steps, which included connecting to the
internet, updating the system clock, creating and formatting and mounting partitions, and using
the [pacstrap] utility to install the base set of packages. After some more configuration,
setting our root password, and choosing our bootloader, we managed to install [Xorg] to get a
minimal graphical interface. From here we could install a desktop environment or a more
complete window manager than the default one, but that can be a task for a future meeting.

<img src="../assets/img/archmemes.png" alt="Arch Linux memes">

[^1]: For a different distribution's take on this principle,
see [Kiss Linux](https://kisslinux.org/)

[Arch Linux]: https://archlinux.org/
[KISS]: https://en.wikipedia.org/wiki/KISS_principle
[wiki]: https://wiki.archlinux.org/
[AUR]: https://aur.archlinux.org/
[installation guide]: https://wiki.archlinux.org/title/Installation_guide
[Quickemu]: https://github.com/wimpysworld/quickemu
[QEMU]: https://www.qemu.org/
[pacstrap]: https://man.archlinux.org/man/pacstrap.8
[Xorg]: https://www.x.org/
