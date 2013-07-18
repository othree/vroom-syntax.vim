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
syntax match   vroomSlideTitle     ".\+" contained

syntax match   vroomSlideItem      "^\s*\zs\*" contained
syntax match   vroomSlideItem      "^\s*\zs•" contained
syntax match   vroomSlideNextItem  "\*" contained
syntax match   vroomSlideNextItem  "•" contained
syntax match   vroomSlideNextMark  "^+" contained nextgroup=vroomSlideNextItem skipwhite

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

for ext in ftypes
  let has = 0
  if search("^---- \\+".ext.'\>', 'n')
    let has = 1
  endif
  if ext == 'viml' && search("^g\?vimrc:")
    let has = 1
  endif
  if has == 1
    let ft = ext
    if ext == 'pl'    | let ft = 'perl'         | endif
    if ext == 'rb'    | let ft = 'ruby'         | endif
    if ext == 'py'    | let ft = 'python'       | endif
    if ext == 'hs'    | let ft = 'haskell'      | endif
    if ext == 'js'    | let ft = 'javascript'   | endif
    if ext == 'as'    | let ft = 'actionscript' | endif
    if ext == 'viml'  | let ft = 'vim'          | endif
    if ext == 'shell' | let ft = 'sh'           | endif
    if !exists('s:'.ft.'_got')
      let s:{ft}_got = 1
      exe 'syntax include @SlideC'.ft.' syntax/'.ft.'.vim'
      if exists('b:current_syntax') | unlet b:current_syntax | endif
    endif
    exe 'syntax region  vroomCode'.ext.' start="^---- '.ext.'\>\S*$" end="^\ze----" contains=@SlideC'.ft.',@vroomCodes'
    if ext == 'viml'
      syntax region vroomConfigVim start="^g\?vimrc:" end="^\ze\S" contains=@SlideCvim,vroomConfig
    endif
  endif
endfor

syntax cluster vroomCodes          contains=vroomSlide

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

if main_syntax == 'vroom'
  unlet main_syntax
endif

let &cpo = s:cpo_save
unlet s:cpo_save
