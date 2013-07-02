" Vim syntax script
" Author: othree <othree@gmail>
" Last Change: June 26, 2013
" URL: https://github.com/othree/vroom-syntax.vim

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'vroom'
endif

let s:cpo_save = &cpo
set cpo&vim

syntax match   vroomComment        "^#.*"

syntax match   vroomSlideTitleMark "^==" nextgroup=vroomSlideTitle skipwhite contained
syntax match   vroomSlideTitle     "[^\n]\+" contained

syntax match   vroomSlideItem      "^\s*\zs\*" contained
syntax match   vroomSlideItem      "^\s*\zs•" contained
syntax match   vroomSlideNextItem  "\s*\zs\*" contained
syntax match   vroomSlideNextItem  "\s*\zs•" contained
syntax match   vroomSlideNextMark  "^+" contained nextgroup=vroomSlideNextItem

syntax match   vroomSlideString    "'[^']\+'" contained
syntax match   vroomSlideString    '"[^"]\+"' contained
syntax match   vroomSlideEnhance   '\*[^*]\*' contained

syntax region  vroomSlideBlock     start="^----" end="^\ze----" contains=@vroomContent,vRoomSlide

syntax cluster vroomContent        contains=vroomSlideItem,vroomSlideString,vroomSlideEnhance,vroomSlideTitleMark,vroomSlideNextMark,vroomSlide

syntax match   vroomConfig         "\h\+:" contained
syntax region  vroomConfigBlock    start="^---- \+config" end="^\ze----" contains=@vroomConfigs

syntax cluster vroomConfigs        contains=vroomConfig,vroomComment,vroomSlide,vroomConfigVim

syntax region  vroomSlideBigTitleBlock    start="^\zs---- \+center" end="^\ze----" contains=vroomSlide,vroomSlideBigTitle
syntax match   vroomSlideBigTitle       "^\w.*" contained

let ftypes = [ 'pl', 'pm', 'ruby', 'rb', 'python', 'py', 'haskell', 'hs', 'javascript', 'js', 'actionscript', 'as', 'shell', 'sh', 'php', 'java', 'yaml', 'xml', 'json', 'html', 'make', 'diff', 'conf', 'viml', 'help']

" syntax region  vroomCodeSlideBlock     start="^\zs---- \+\(perl\|pl\|pm\|ruby\|rb\|python\|py\|haskell\|hs\|javascript\|js\|actionscript\|as\|shell\|sh\|php\|java\|yaml\|xml\|json\|html\|make\|diff\|conf\|viml\)\>" end="^\ze----" contains=@vroomCodes

let hasftypes = []
for t in ftypes
  if search("^---- \\+".t.'\>', 'n')
    call add(hasftypes, t)
  endif
endfor
for t in hasftypes
  let ext = t
  for p in split(&rtp, ',')
    if t == 'pl' | let ext = 'perl' | endif
    if t == 'rb' | let ext = 'ruby' | endif
    if t == 'py' | let ext = 'python' | endif
    if t == 'hs' | let ext = 'haskell' | endif
    if t == 'js' | let ext = 'javascript' | endif
    if t == 'as' | let ext = 'actionscript' | endif
    if t == 'viml' | let ext = 'vim' | endif
    if t == 'shell' | let ext = 'sh' | endif
    if !exists('s:'.ext.'_get') && filereadable(p.'/syntax/'.ext.'.vim')
      let s:{ext}_get = 1
      exe 'syntax include @SlideC'.ext.' '.p.'/syntax/'.ext.'.vim'
      if exists('b:current_syntax') | unlet b:current_syntax | endif
    endif
  endfor
  exe 'syntax region  vroomCode'.t.' start="^---- '.t.'\>\S*$" end="^\ze----" contains=@SlideC'.ext.',@vroomCodes'
endfor

syntax cluster vroomCodes          contains=vroomSlide

if search("^vimrc:") || search("^gvimrc:")
  if !exists('s:vim_get')
    for p in split(&rtp, ',')
      let s:vim_get = 1
      exe 'syntax include @SlideCvim '.p.'/syntax/vim.vim'
      if exists('b:current_syntax') | unlet b:current_syntax | endif
    endfor
  endif
  syntax region vroomConfigVim start="^g\?vimrc:" end="^\ze\S" contains=@SlideCvim,vroomConfig
endif

syntax match   vroomSlide          "^\zs----\ze" nextgroup=vroomSlideConfig skipwhite contained
syntax match   vroomSlideConfig    "[,0-9A-Za-z_-]\+" contained

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_vroom_syn_inits")
  if version < 508
    let did_vroom_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink vroomConfig          Type

  HiLink vroomSlide           VertSplit
  HiLink vroomSlideConfig     Type
  HiLink vroomComment         Comment

  HiLink vroomSlideTitleMark  Operator
  HiLink vroomSlideTitle      Special
  HiLink vroomSlideBigTitle   Special
  HiLink vroomSlideNextMark   Operator
  HiLink vroomSlideItem       Special
  HiLink vroomSlideString     String
  HiLink vroomSlideEnhance    String

  HiLink vroomSlideNextItem   vroomSlideItem
endif

let b:current_syntax = 'vroom'

let &cpo = s:cpo_save
unlet s:cpo_save
