NOT UNIX                                                                                            
                                                                                                    
File management                                                                                     
                                                                                                    
           d1 ls f1 f2 ...    list f1 f2 ... from dir d1, default .                                 
    f3 f4 ... mv f1 f2 ...    move f1 f2 ... to f3 f4 ... (scalar extension), default TMP (temp dir)
    f3 f4 ... cp f1 f2 ...    copy f1 f2 ... to f3 f4 ... (scalar extension), default .             
        d3 mkdir d1 d2 ...    make dirs d1 d2 ... into dir d3, default .                            
              cd d1 d2 ...    change to directory d1/d2/... and return dir before changing          
    d3 d4 ... cd d1 d2 ...    change to directory d1/d2/.../d3/d4/... and return dir after changing 
           ⍺(⍺⍺ pushd d1)⍵    change to d1, run ⍺ ⍺⍺ ⍵ and return to current dir, default ⊢         
                                                                                                    
    with f1 f2 f3 f4 ... file (or dir) names, d1 d2 d3 d4 ... dir names, and n number               
                                                                                                    
Text editing                                                                                        
                                                                                                    
           t2 cat t1    concatenate contents of t1 and t2, default ⍬                                
           t2 tac t1    concatenate reverse contents of t2 and t1, default ⍬                        
           n head t1    get first n lines of t1, default 10                                         
           n tail t1    get last n lines of t1, default 10                                          
          r  grep t1    get lines of t1 that match s, default grep this manual                      
          r vgrep t1    get lines of t1 that do not match s, default empty lines                    
          ⍺  sort t1    ascending sort lines of t1 according to ⍺, default t1                       
          ⍺ rsort t1    descending sort lines of t1 according to ⍺, default t1                      
           ⍺(⍺⍺ ed)f    run ⍺ ⍺⍺ cat f and save to f, default ⊢                                     
         ⍺(⍺⍺ x ⍵⍵)s    substitute by ⍺⍺ or run ⍺∘⍺⍺ on matches of ⍵⍵ in s, default ⊢               
         ⍺(⍺⍺ y ⍵⍵)s    substitute by ⍺⍺ or run ⍺∘⍺⍺ between matches of ⍵⍵ in s, default ⊢          
         ⍺(⍺⍺ g ⍵⍵)s    run ⍺∘⍺⍺ s if s matches ⍵⍵, default ⊢                                       
         ⍺(⍺⍺ v ⍵⍵)s    run ⍺∘⍺⍺ s if s does not match ⍵⍵, default ⊢                                
            c cut t1    cut t1 in fields with separator c, default space                            
    c join t1 t2 ...    join lines of t1 t2 ... with c, default space or new line                   
            f tee t1    save t1 to file f and return it, default stdout                             
             r wc t1    count occurences of r in t1, default words                                  
         d(⍺⍺ find)f    find file f with condition ⍺⍺ true, or matching ⍺⍺ at d, default .          
                        (⍺⍺ gets a namespace argument with fields: name bytes modified owner)       
                                                                                                    
    with t1 t2 ... text (string with dir or file name, or list of lines), n number,                 
    r regex (as a string), s string, c character, f file name and d dir name                        
                                                                                                    
TODO: sed, awk, mkfifo, error checking (!), tests (!!), ...                                         
SEE ALSO: unix, gnu, plan 9                                                                         
