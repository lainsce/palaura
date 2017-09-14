# ![icon](data/icon.png) Paraula
## Find any word's definition with this handy dictionary.
[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.lainsce.paraula)

![Screenshot](data/shot.png)

## Dependencies

Please make sure you have these dependencies first before building.

```
granite
gtk+-3.0
meson
libsoup2.4
libjson-glib
libgio
libgthread
libgee
```

## Building

Simply clone this repo, then:

```
$ meson build && cd build
$ mesonconf -Dprefix=/usr
$ sudo ninja install
```


## Miscellanea

Uses the Pearson API for definitions & lookups.