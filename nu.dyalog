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

    ∇ r←Run(cmd input);p
      :Select cmd
      :Case 'nu'
          :If 0<≢input ⋄ r←⎕SE.nu⍎input ⋄ →0 ⋄ :EndIf
          p←¯10↑']nu '
      ∆R: ⍞←p ⋄ input←⍞
          :If p≢(≢p)↑input ⋄ ⍎input ⋄ →0 ⋄ :EndIf
          input↓⍨←≢p ⋄ →(0=≢input)/0
          :Trap 0
              :If('-'=⊃input)∧'?',⍛≡∪1↓input
                  ⎕SE.UCMD'nu ',input
              :Else
                  ⎕SE.nu.{85:: ⋄ ⎕←1(85⌶)⍵}input
              :EndIf
          :Else
              ⎕←⎕DMX.(EM(OSError{⍵,2⌽(×≢⊃⍬⍴2⌽⍺,⊂'')/'") ("',⊃⍬⍴2⌽⍺}Message))
          :EndTrap
          →∆R
      :Case 'PATH'
          r←⎕PATH{⊃(⊣,' ',⊢)/∪(⊂⍵),⍨' '(≠⊆⊢)⍺}←'⎕SE.nu'
      :EndSelect
    ∇ 

    ∇ r←level Help cmd
      :Select cmd
      :Case 'nu'
          r←⊂List[1].Desc,'. nu is NOT UNIX'
          r,←⊂']nu man  ⍝ full manual'
          r,←⊂']nu      ⍝ REPL (empty to leave)'
      :Case 'PATH'
          r←⊂List[2].Desc
      :EndSelect
    ∇

:EndNamespace
