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

syntax match   vroomComment        "^#.*"
syntax match   vroomSlide          "^----" nextgroup=vroomSlideConfig skipwhite
syntax match   vroomSlideConfig    "[,0-9A-Za-z_-]\+" contained

syntax match   vroomSlideTitleMark "^==" nextgroup=vroomSlideTitle skipwhite
syntax match   vroomSlideTitle     "[^\n]\+" contained
syntax match   vroomSlideNextMark  "^+"

syntax match   vroomSlideItem      "^\s*\*"
syntax match   vroomSlideItem      "^+\zs\s*\*"
syntax match   vroomSlideString    "'[^']\+'"
syntax match   vroomSlideString    '"[^"]\+"'
syntax match   vroomSlideEnhance   '\*[^*]\*'

syntax cluster vroomContent        contains=vroomSlideItem,vroomSlideString,vroomSlideEnhance

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_javascript_syn_inits")
  if version < 508
    let did_javascript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink vroomSlide           Constant
  HiLink vroomSlideConfig     Type
  HiLink vroomComment         Comment

  HiLink vroomSlideTitleMark  Operator
  HiLink vroomSlideTitle      Special
  HiLink vroomSlideNextMark   Operator
  HiLink vroomSlideItem       Special
  HiLink vroomSlideString     String
  HiLink vroomSlideEnhance    String

endif
