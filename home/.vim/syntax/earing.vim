" Vim syntax file
"
" Language: Earing
" Author: Zed A. Shaw (based on the Ragel one by Adrian Thurston)

syntax clear

" Comments
syntax region erComment start="\/\*" end="\*\/"
" Comments
syntax match erComment "#.*$"

" Imports and library includes
syntax keyword erImports %library %import

" Anything preprocessor
syntax match erDirective "%[a-zA-Z_]*"

" Strings
syntax match erLiteral "'\(\\.\|[^'\\]\)*'"
syntax match erLiteral "\"\(\\.\|[^\"\\]\)*\""

" functions and such
syntax keyword erKeyword function end

" all the operators

syntax keyword erOperator addr addi addxr addxi addcret addciet subr subi subxr subxi subcr subci rsbr rsbi mulr muli hmulr hmuli divr divi modr modi andr andi orr ori xorr xori lshr lshi rshr rshi negr notr ltr lti ler lei gtr gti ger gei eqr eqi ner nei unltr unler ungtr unger uneqr ltgtr ordr unordr movr movi extr roundr truncr floorr ceilr hton ntoh ldr ldi ldxr ldxi str sti stxr stxi prepare pusharg getarg retval  calli callr finish finishr jmpi jmpr ret prolog leaf allocai

syntax keyword erBranch bltr blti bler blei bgtr bgti bger bgei beqr beqi bner bnei bunltr bunler bungtr bunger buneqr bltgtr bordr bunordr bmsr bmsi bmcr bmci boaddr boaddi bosubr bosubi

" Types
syntax keyword erType uint int void uchar char ushort short ulong long float double ptr
syntax keyword erType ui i void uc c us s ul l float d p

" Numbers
syntax match erNumber "[0-9][0-9]*"
syntax match erNumber "0x[0-9a-fA-F][0-9a-fA-F]*"
syntax match erFloat "[0-9][0-9]*\.[0-9][0-9]*"

" Identifiers
syntax match anyId "[a-zA-Z_][a-zA-Z_0-9]*"

syntax match erLabels "[a-zA-Z_][a-zA-Z_0-9]*:"

syntax keyword erRegisters R0 R1 R2 V0 V1 V2 RET NOREG FP

" Some that help in catching errors
syntax match erBadRegister "[A-Z][3-9]"
syntax match erBadParens "([^)]*$"

"
" Specifying Groups
"
hi link erComment Comment
hi link erDirective Macro
hi link erLiteral String
hi link erType StorageClass
hi link erKeyword Keyword
hi link erOperator Keyword
hi link erNumber Number
hi link erKeywords Type
hi link erImports Include
hi link erLabels Label
hi link erFloat Float
hi link erRegisters Debug
hi link erBadRegister Error
hi link erBadParens Error
hi link erBranch Repeat
hi link anyId Function

set nocindent

let b:current_syntax = "earing"
