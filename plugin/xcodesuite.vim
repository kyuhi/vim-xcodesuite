if &cp || exists( 'g:loaded_xcode_suite' )
    finish
endif
let s:save_cpo = &cpo
set cpo&vim

command! XCodeOpen call xcodesuite#open()
" command! XCodeBuild call xcodesuite#build()

let g:loaded_xcode_suite = 1

let &cpo = s:save_cpo
unlet s:save_cpo
