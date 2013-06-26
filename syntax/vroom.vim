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
syntax match   vroomSlide          "^\zs----" nextgroup=vroomSlideConfig skipwhite
syntax match   vroomSlideConfig    "[,0-9A-Za-z_]\+" contained

syntax match   vroomSlideTitleMark "^==" nextgroup=vroomSlideTitle skipwhite contained
syntax match   vroomSlideTitle     "[^\n]\+" contained
syntax match   vroomSlideNextMark  "^+" contained

syntax match   vroomSlideItem      "^\s*\*" contained
syntax match   vroomSlideItem      "^+\zs\s*\*" contained
syntax match   vroomSlideString    "'[^']\+'" contained
syntax match   vroomSlideString    '"[^"]\+"' contained
syntax match   vroomSlideEnhance   '\*[^*]\*' contained

syntax region  vroomSlideBlock     start="^\zs----" end="^\ze----" contains=@vroomContent

syntax cluster vroomContent        contains=vroomSlideItem,vroomSlideString,vroomSlideEnhance,vroomSlideTitleMark,vroomSlideNextMark,vroomSlide

syntax region  vroomCodeSlideBlock     start="^\zs---- \(perl\|pl\|pm\|ruby\|rb\|python\|py\|haskell\|hs\|javascript\|js\|actionscript\|as\|shell\|sh\|php\|java\|yaml\|xml\|json\|html\|make\|diff\|conf\|viml\)" end="^\ze----" contains=@vroomCodes

syntax cluster vroomCodes          contains=vroomSlide

syntax match   vroomConfig         "\h\+:" contained
syntax region  vroomConfigBlock    start="^\zs---- config" end="^\ze----" contains=@vroomConfigs

syntax cluster vroomConfigs        contains=vroomConfig,vroomComment,vroomSlide

syntax region  vroomSlideBigTitleBlock    start="^\zs---- center" end="^\ze----" contains=vroomSlide,vroomSlideBigTitle
syntax match   vroomSlideBigTitle       "^\w.*" contained

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

endif
