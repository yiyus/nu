:Namespace nuCmd
⍝ Custom user command

    ⎕IO←1 ⋄ ⎕ML←1
    ⎕SE.Tatin.LoadDependencies⊂'[MyUCMDs]/nu'

    ∇ r←List
      r←⎕NS¨2⍴⊂⍬
      r.Name←'nu' 'PATH'
      r.Group←⊂'notunix'
      r[1].Desc←'Run expression inside nu namespace'
      r[2].Desc←'Add nu namespace to ⎕PATH'
      r.Parse←'' ''
    ∇ 

    ∇ r←Cmd input
      :If{0::0 ⋄ 1=⊃1⎕NINFO⍵}input
          r←⎕SE.nu.lc''⊣⎕←⎕SE.nu.cd''⊣⎕SE.nu.cd input
      :Else
          r←⎕SE.nu.{85:: ⋄ ⎕←1(85⌶)⍵}input
      :EndIf
    ∇

    ∇ r←Run(cmd input);p
      :Select cmd
      :Case 'nu'
          :If 0<≢input
              :If{0::0 ⋄ 1=⊃1⎕NINFO⍵}input
                  r←⎕SE.nu.lc''⊣⎕←⎕SE.nu.cd''⊣⎕SE.nu.cd input
              :Else
                  r←⎕SE.nu⍎input
              :EndIf
              →0
          :EndIf
          p←¯10↑']nu '
      ∆R: ⍞←p ⋄ input←⍞
          :Trap 0
              :If p≢(≢p)↑input
                  input←((+/∧\)' '∘=)⍛↓input
                  :If']'=⊃input ⋄ ⎕SE.UCMD 1↓input ⋄ :Else ⋄ ⎕SE.THIS⍎input ⋄ :EndIf
              :Else
                  input↓⍨←≢p ⋄ →(0=≢input)/0
                  :If('-'=⊃input)∧'?',⍛≡∪1↓input
                      ⎕SE.UCMD'nu ',input
                  :ElseIf{0::0 ⋄ 1=⊃1⎕NINFO⍵}input
                      ⎕←⎕SE.nu.lc''⊣⎕←⎕SE.nu.cd''⊣⎕SE.nu.cd input
                  :Else
                      ⎕SE.nu.{85:: ⋄ #.{⎕←⍵}1(85⌶)⍵}input
                  :EndIf
              :EndIf
          :Else
              ⎕←⎕DMX.(EM(OSError{⍵,2⌽(×≢⊃⍬⍴2⌽⍺,⊂'')/'") ("',⊃⍬⍴2⌽⍺}Message))
          :EndTrap
          →∆R
      :Case 'PATH'
          ⎕PATH{⊃(⊣,' ',⊢)/∪(⊂⍵),⍨' '(≠⊆⊢)⍺}←'⎕SE.nu'
          r←⎕PATH
      :EndSelect
    ∇ 

    ∇ r←level Help cmd
      :Select cmd
      :Case 'nu'
          r←⊂List[1].Desc,'. nu is NOT UNIX'
          r,←⊂']nu man  ⍝ full manual'
          r,←⊂']nu      ⍝ REPL (empty to leave)'
          :If level>0
              r,←⊂''
              r,←⊂'The REPL will run the given expression in the nu namespace.'
              r,←⊂'If the expression is a directory name, it will change to that'
              r,←⊂'directory and list its contents (using lc)'
          :EndIf
      :Case 'PATH'
          r←⊂List[2].Desc
      :EndSelect
    ∇

:EndNamespace
