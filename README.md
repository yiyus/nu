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
    ⍝ HELP: man
      man                                           ⍝ show the manual
      'cd'grep man                                  ⍝ search the manual

    ⍝ NAVIGATION: cd HOME TMP BIN
      cd'.' ⋄ cd'' ⋄ cd⍬                            ⍝ current directory (pwd)
      cd'dir' ⋄ cd'..' ⋄ cd'/'                      ⍝ change to dir, parent and root directory
      cd HOME ⋄ cd TMP ⋄ cd BIN                     ⍝ change to $HOME, $TMP, and nu's recycle bin
      cd HOME'Documents'                            ⍝ change to $HOME/Documents
      cd'a1' 'b2' 'c3'                              ⍝ change to a1/b2/c3
      d←cd'..' ⋄ cd d                               ⍝ change to parent dir and come back
      d←cd HOME ⋄ d cd←'..' ⋄ d cd←d ⋄ cd d         ⍝ move around and come back (pushd/popd)

    ⍝ FILE INFO: ls lc ll find du date
      ls'' ⋄ ls'*.md' ⋄ ls'*/' ⋄ 'dir'ls''          ⍝ list files, markdown files, dirs, files in dir
      ls'a.txt' 'b.txt' ⋄ 'dir1' 'dir2'ls¨⊂'*.md'   ⍝ list several files, several dirs
      lc'' ⋄ ll'' ⋄ 5 lc'*.md' ⋄ 5 ll'*/'           ⍝ columns or full listing, with optional row count
      find'*.apl?' ⋄ 'dir'find'*.txt' ⋄ find''      ⍝ recursive find apl files, txt files in dir, all files
      du'*.png' ⋄ date'*.png'                       ⍝ size and modification date
      1e6 du'*' ⋄ 1e8 du find''                     ⍝ files larger than 1MB or 100MB recursively
      2025 date'*.md' ⋄ (3↑⎕TS)date find''          ⍝ md files modified since 2025, all since today

    ⍝ FILE MANAGEMENT: cp mv mk
      'back.md'cp'important.md' ⋄ 'back/'cp'dir'    ⍝ copy file, copy directory (recursively)
      'dir'cp'1.ps' '2.ps' ⋄ cp'dir/*'              ⍝ copy files to dir, copy files to current dir
      'new.md'mv'old.md' ⋄ 'newdir'mv'olddir'       ⍝ move (rename) file and directory
      'dir'mv'1.ps' '2.ps'                          ⍝ move files to dir
      mv'*.tmp' ⋄ mv BIN                            ⍝ move to BIN (delete), empty BIN (permanently)
      mk'dir/' ⋄ 'dir'mk'sub/' 'sub2/'              ⍝ make dir, make subdirs inside dir
      mk'a/b/c/'                                    ⍝ make nested directories
      mk'empty.txt' ⋄ 'dir'mk'a.txt' 'b.txt'        ⍝ create empty file, create files inside dir
      mk'log-&.txt' ⋄ mk'run-&/'                    ⍝ create empty files, & expands to a unique string
      mk'' ⋄ mk'/' ⋄ 'dir'mk'' ⋄ 'dir'mk'/'         ⍝ create temp file and dir in TMP and inside dir
      mk 2                                          ⍝ get 2 tokens to use as pipe (see BACKGROUND PROCESSES)

    ⍝ TEXT FILES: cat head tail sort rsort grep vgrep wc wcl tee teea
      cat'a.txt'                                    ⍝ read file as a vector of lines
      cat'this is a line' 'and another one'         ⍝ nested strings are lines
      'a.txt'cat'b.txt' ⋄ ⊃cat/files                ⍝ concatenate files
      head'a.txt' ⋄ 20 head'a.txt'                  ⍝ first 10 or first 20 lines (as matrix)
      tail'a.txt' ⋄ 20 tail'a.txt'                  ⍝ last 10 or last 20 lines (as matrix)
      sort'a.txt' ⋄ du⍛sort'*/'                     ⍝ sort lines A-z, sort dirs by ascending size
      rsort'a.txt' ⋄ du⍛rsort'*/'                   ⍝ sort lines z-A, sort dirs by descending size
      '^re$'grep'a.txt' ⋄ '^re$'vgrep'a.txt'        ⍝ lines matching or not matching regexp
      grep'' ⋄ vgrep'' ⋄ grep HOME ⋄ vgrep HOME     ⍝ list of dirs, list of files in current and HOME dir
      wc'a.txt' ⋄ '[A-Z]+'wc'a.txt'                 ⍝ count words, count uppercase runs
      wcl'a.txt' ⋄ '^TODO'wcl'a.txt' ⋄ wcl TMP      ⍝ count lines, lines starting with TODO, files in TMP
      'out.txt'tee text                             ⍝ write text to out.txt (and return it as shy result)
      tee'out.txt'                                  ⍝ print file to ⎕ (and return it as shy result)
      'log.txt'teea text ⋄ p teea'log.txt'          ⍝ append text to log.txt, write to pipe without closing it

    ⍝ TEXT EDITING: cut join x y g v sed ed
      cut text_with_nl ⋄ ','cut'a,b,,c'             ⍝ split on linebreaks (preserve empties), or on ⍺ (no empties)
      ''cut'one  two',TAB,'three'                   ⍝ tokenise on whitespace (drop empties)
      join lines ⋄ ','join'one' 'two' 'three'       ⍝ join with native NL, or with ⍺
      ' 'join words ⋄ join words                    ⍝ join with spaces, or with nothing
      'DONE'x'TODO'⊢text ⋄ ⌽x'\w+'⊢text             ⍝ substitute matches, reverse each word
      '(&)'y'\s+'⊢text ⋄ ⌽y'\.'⊢text                ⍝ wrap non-space runs, reverse sentences
      'j'x'i'x'/\*.*?\*/'⊢text                      ⍝ replace i with j only inside /* ... */
      '-'x'\s+'y'"[^"]*"'⊢text                      ⍝ replace whitespace with - only outside quotes
      1⎕C x'⍝.*'¨cat'eg.apl'                        ⍝ uppercase every comment in this file
      1⎕C g'^⍝'¨text                                ⍝ uppercase lines that start with ⍝
      1⎕C g'urgent'x'(?s).*?\n\n'⊢text              ⍝ uppercase whole paragraphs containing urgent
      1⎕C v'skip'g'error'⊢line                      ⍝ uppercase lines with error unless they contain skip
      ('#'x'^')g'^TODO'¨text                        ⍝ prefix every TODO line with #
      re x⊢text ⋄ re g/text                         ⍝ matches of re in text, lines matching re
      '/old/new'sed'a.txt' ⋄ '|old|new|'sed'a.txt'  ⍝ replace old with new (different separators, same result)
      sed'a.txt' ⋄ ⊃sed⊂line                        ⍝ trim right whitespace of file or line
      '|foo|bar|baz|qux'sed'a.txt'                  ⍝ substitute foo with bar and baz with qux
      '©'x'\(C\)'ed'*.c' '*.h'                      ⍝ in-place rewrite of files
      'tr a-z A-Z'ed'notes.txt'                     ⍝ in-place edit through a shell command

    ⍝ PROCESSES: sh exec
      sh'ps aux | tr a-z A-Z'                       ⍝ run shell command, get stdout as lines
      'tr a-z A-Z'sh'file.txt'                      ⍝ run shell command with file as stdin
      'tr a-z A-Z'sh sh'ps aux'                     ⍝ stdout of one sh into stdin of next (pipe)
      'ps'exec'' ⋄ 'ps'exec'-a' '-u' '-x'           ⍝ exec command, exec command with arguments
      'a-z' 'A-Z'('tr'exec)'file.txt'               ⍝ exec with arguments, file as stdin
      'a-z' 'A-Z'('tr'exec)'echo'exec'hello'        ⍝ pipe exec into exec (no shell involved)
      git←↑'git'exec ⋄ git'status' ⋄ git'log'       ⍝ defined and use git command

    ⍝ BACKGROUND PROCESSES: bg fork kill
      p←mk 1 ⋄ p tee& text ⋄ tee p                  ⍝ create pipe, write to it from another thread, and read it
      p←bg'seq 1 100' ⋄ tee p                       ⍝ launch process and read output from pipe
      out←'cat'bg in←mk 1 ⋄ in tee'hi' ⋄ tee out    ⍝ create pipe, launch process, write to pipe, read output
      p q←bg¨'seq 1 10' 'seq 1 5' ⋄ ↑p cat q        ⍝ run two processes in parallel and gather output
      p←'git'fork'log' ⋄ tee p                      ⍝ fork command and read output
      p←⎕C fork'git'fork'log' ⋄ tee p               ⍝ fork pipeline, apply ⎕C to output
      kill p ⋄ kill t ⋄ kill'*'                     ⍝ close pipe p, kill thread t, or kill all

    ⍝ FULL EXAMPLES
      ↑'^⍝'grep'eg.apl'                             ⍝ sections in this document
      ⍪↑¨'cp'∘grep¨man(cat'eg.apl')                 ⍝ search help and examples
      r←find ⋄ d←grep ⋄ f←vgrep ⋄ s←sort            ⍝ flag-like aliases: recursive, dirs, files, sorted
      'dir'cp r d'a*' ⋄ 're'grep¨f'a*'              ⍝ use flag-like aliases
      2026 5 date(5×2*20)du find'/var/log'          ⍝ files >5MB modified after May 2026
      ⊃du⍛rsort vgrep find''                        ⍝ largest file in subtree
      +/du∘find'*.md'                               ⍝ total size of all md files
      (¯1⎕C)⍛mv(⊂'IMG_*.'),¨'BMP' 'JPG' 'PNG'       ⍝ rename image files to lowercase
      'pdf/'cp'.pdf$'grep'dir/'mv'*.tex' '*.pdf'    ⍝ move tex and pdf files to dir and copy pdfs
      (wcl,wc,du)'eg.apl'                           ⍝ lines, words and bytes of file
      +/wcl¨find'*.py'                              ⍝ total lines across all python files
      'SHELL'∘(×⍤≢grep)¨⍛/ls'*.apl*'                ⍝ apl files mentioning ⎕SHELL
      sed ed find'*.apl?' '*.md' '*.txt'            ⍝ strip whitespace from files
      ⍕,∘≢⌸'[A-z]+'x⊢⎕C cat'doc.md'                 ⍝ word-frequency table for a document
      ⍕,∘≢⌸git'log' '--pretty=format:%an'           ⍝ git commits by author (uses git←↑'git'exec)
      ↑'#'∘={' '@⍺⍺(1+⍺⍺)⍛/⍵}¨'^#+'g/cat'file.md'   ⍝ table of contents of markdown file
      ↑{⍵(↑'TODO|FIXME|XXX'grep ⍵)}¨ls'*.apl*'      ⍝ todo list
      tpl←{⍺ tee sed↑{join⍎1↓⍵}x'^<.*$'¨cat ⍵}      ⍝ (UNSAFE!) templates: 'README.md'tpl'README.tpl'
```

## Manual

    NOT UNIX

    Files and processes

             ... cd d1 ...   change to d1/..., return ⍺ pushing current dir, empty by default

          d1 ... ls f1 ...   list f1 ... from d1/..., default .
        d1 ... find f1 ...   list f1 ... from d1/... recursively, default .
         n ... date f1 ...   modification date of f1 ... or list elements in f1 ... newer than n ...
               n du f1 ...   size of f1 ... or list elements in f1 ... larger than n
               n lc f1 ...   format list f1 ... by columns in max n rows, default 10
               n ll f1 ...   format full list f1 ... as list of max n rows sorted by size, default 16

          f2 ... mv f1 ...   move f1 ... to f2 ... (scalar extension), default BIN, mv BIN to empty
          f2 ... cp f1 ...   copy f1 ... to f2 ... (scalar extension), default .
          d1 ... mk fn ...   make fn pipes or create fn ... in d1/..., default . (empty for temp)

                ... sh ...   run shell command ⍵ or shell command ⍺ with stdin ⍵, empty for repl
                ... bg ...   run shell command in a different thread and return stdout pipe
           ...(⍺⍺ exec)...   exec command ⍺⍺ with arguments ⍵ or with arguments ⍺ and input ⍵
           ...(⍺⍺ fork)...   exec in a different thread and return stdout pipe
                  kill ...   kill thread or close pipe, '*' to kill all threads

        with f1 ..., f2 ... file or dir paths (right arg f1 ... may include wildcards, empty is .),
        d1 ... dir names (path components), n ... numbers, and fn file or dir name or integer

        HOME is the home directory. TMP is the system temp dir. BIN is nu's recycle bin dir

    Text editing

                 t2 cat t1   concatenate contents of t1 and t2, default ⍬
                 n head t1   format first n lines of t1 as matrix, default 10
                 n tail t1   format last n lines of t1 as matrix, default 10
                ⍺  sort t1   ascending sort lines of t1 according to ⍺, default t1
                ⍺ rsort t1   (sort -r) descending sort lines of t1 according to ⍺, default t1
                r  grep t1   get lines of t1 matching s, default $/ (dirs)
                r vgrep t1   (grep -v) get lines of t1 not matching s, default $/ (files)
                 f  tee t1   write t1 to f and return it, pipes are closed, default ⎕
                 f teea t1   (tee -a) append t1 to f and return it, pipes are not closed, default ⍞
                   r wc t1   count occurences of r in t1, default \S+ (words)
                  r wcl t1   (wc -l) count lines with occurences of r in t1, default .* (all lines)
              s ... sed t1   apply substitution pattern /a/b/... (or |a|b|.., etc), default -\s+$
              ...(⍺⍺ ed)f1   apply ⍺∘⍺⍺ on f and write back to f, ⍺⍺ string to run with exec, default ⊢

          ⍺(⍺⍺ x ⍵⍵)s1 ...   substitute by ⍺⍺ or apply ⍺∘⍺⍺ on matches of ⍵⍵ in s, default ⊢
          ⍺(⍺⍺ y ⍵⍵)s1 ...   substitute by ⍺⍺ or apply ⍺∘⍺⍺ between matches of ⍵⍵ in s, default ⊢
                             (right function to x or y to apply ⍺ to matches or non-matches of ⍺⍺)
          ⍺(⍺⍺ g ⍵⍵)s1 ...   apply ⍺∘⍺⍺ s if s matches ⍵⍵, default ⊢
          ⍺(⍺⍺ v ⍵⍵)s1 ...   apply ⍺∘⍺⍺ s if s does not match ⍵⍵, default ⊢
                             (right function to g or v to apply ⍺ to lines matching or not ⍺⍺)
             s2 cut s1 ...   split ⍵ at occurences of ⍺, empty for whitespace, default linebreak
            s2 join s1 ...   join elements of ⍵ with ⍺, default NL or empty

        with t1 t2 path or glob string, or matrix, or list of lines, or pipe (negated to not close),
        n number, r regex string, s s1 s2 ... strings, f1 file name

        The variables TAB CR LF contain tab, carriage return and linefeed characters.
        CRLF is the windows new line, and NL the native one (LF or CRLF)

    SEE ALSO: unix, gnu, plan 9
