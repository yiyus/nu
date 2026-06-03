# NOT UNIX

`nu` is a (cross-platform) shell environment built natively inside Dyalog APL.
It replaces standard UNIX binaries with APL functions that compose with the rest of the language.
`nu` provides:

* Filesystem inspection and management functions (`ls`, `cp`, `mv`...) that consume and return lists of file paths
* Tools to call external programs, including background processes and pipes (`sh`, `exec`, `bg`, `fork`)
* Text manipulation functions (`cat`, `head`, `tee`...) that can form complex pipelines processing lines of text as nested strings
* Advanced editing through [**structural regex**](https://doc.cat-v.org/bell_labs/structural_regexps/se.pdf) via operators (`x`, `y`, `g`, `v`)

## Examples

```apl
<(⊂4⍴''),¨cat'eg.apl'
```

## Manual

<↓(⊢,⍨''⍴⍨4,⍨⊃∘⍴)man

## Setup

Quick ephimeral setup:

```apl
      ]get https://raw.githubusercontent.com/yiyus/nu/refs/heads/main/nu.apln
```

Installation with [Tatin](tatin.dev) (includes user command):

```apl
      ]TATIN.InstallPackages [tatin-test]yiyus-nu [MyUCMDs]
      ]UReset
```
