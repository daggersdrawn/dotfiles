" dcs.vim - Delete/Change Surroundings
" Maintainer:   Tim Pope <vimNOSPAM@tpope.info>
" $Id$
"
" Usage:
"
" "ds" is a mapping which deletes the surroundings of a text object--the
" difference between the "inner" object and "an" object.  See the :help on
" text-objects for details.  This is easiest to understand with some examples;
" in the following, * represents the cursor position.
"
" Old                       Keystroke   New
" "Hello *world!"           ds"         Hello world!
" (123+4*56)/2              ds(         123+456/2
" <div>Yo!</div>            dst         Yo!
"
" "cs" does as above, but rather than remove the surroundings, it replaces
" them with something else.  It takes two arguments.  Once again, examples are
" in order.
"
" Old                       Keystroke   New
" "Hello *world!"           cs"'        'Hello world!'
" "Hello *world!"           cs"tq<CR>   <q>Hello world!</q>
" (123+4*56)/2              cs([        [123+456]/2
" <div>Yo!</div>            cstp<CR>    <p>Yo!</p>
"
" Note worthy, here, is the use of a "t" for the second argument.  This
" prompts for the contents of the tag to insert.  You may specify attributes
" here and they will be stripped from the closing tag.

" Coming soon: a visual mode variant.

" ============================================================================

" Exit quickly when:
" - this plugin was already loaded (or disabled)
" - when 'compatible' is set
if (exists("g:loaded_dcs") && g:loaded_dcs) || &cp
    finish
endif
let g:loaded_dcs = 1

let s:cpo_save = &cpo
set cpo&vim


function! s:DelSurround(...) " {{{1
    let char = nr2char(a:0 ? a:1 : getchar())
    let original = @@
    let @@ = ""
    exe "norm di".char
    let keeper = @@
    if @@ == ""
        let @@ = original
        return ""
    endif
    let oldline = getline('.')
    if char == "p"
        " Not 100% reliable
        norm! dk
    elseif char == "s"
        " Do nothing
        let @@ = ""
    else
        exe "norm! d".(char =~# "[\"'`]" ? "2i" : "a").char
    endif
    let removed = @@
    let oldhead = strpart(oldline,0,strlen(oldline)-strlen(removed))
    let oldtail = strpart(oldline,  strlen(oldline)-strlen(removed))
    if oldtail == removed && col('.') + 1 == col('$')
        if oldhead =~# '^\s*$' && a:0 < 2
            let keeper = substitute(keeper,'\%^\n\s*\(.*\)\n\s*\%$','\1','')
        endif
        let pcmd = "p"
    else
        let pcmd = "P"
    endif
    if a:0 > 1
        " Duplicate b's are just placeholders
        let pairs = "b()B{}b[]b<>"
        let newchar = nr2char(a:2)
        let idx = stridx(pairs,newchar)
        if idx >= 0
            let idx = idx / 3 * 3
            let keeper = strpart(pairs,idx+1,1) . keeper . strpart(pairs,idx+2,1)
        elseif newchar == "p"
            let keeper = "\n" . keeper . "\n\n"
        elseif newchar == "t"
            let tag = input("tag: ")
            let keeper = "<".tag.">".keeper."</".substitute(tag," .*",'','').">"
        else
            let keeper = newchar . keeper . newchar
        endif
    endif
    let @@ = keeper
    exe "norm! ".(a:0 < 2 ? "]" : "").pcmd."`["
    let @@ = removed
endfunction " }}}1

nnoremap <silent> <SID>deletesurround :call <SID>DelSurround(getchar())<CR>
nnoremap <silent> <SID>changesurround :call <SID>DelSurround(getchar(),getchar())<CR>
nnoremap <script> ds <SID>deletesurround
nnoremap <script> cs <SID>changesurround

let &cpo = s:cpo_save

" vim:set ft=vim ff=unix ts=8 sw=4 sts=4:
