%{
//Definition
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "hash.h"
    typedef unsigned long long int ulli;
    ulli Lines = 1;
    ulli CharPos = 1;
%}
/** Rules **/

/* Others */
NewLine_CRLF \r\n
NewLine_LF \n
NewLine {NewLine_CRLF}|{NewLine_LF}
WhiteSpace [ ]
Tab \t

/* Symbol */
Comma \,
Colon \:
Semicolon \;
Parentheses \(|\)
Square_Brackets \[|\]
Brackets \{|\}
Symbol {Comma}|{Colon}|{Semicolon}|{Parentheses}|{Square_Brackets}|{Brackets}

/* Operator */
Addition_OP1 \+
Addition_OP2 \+\+
Addition {Addition_OP1}|{Addition_OP2}
Subtraction_OP1 \-
Subtraction_OP2 \-\-
Subtraction {Subtraction_OP1}|{Subtraction_OP2}
Multiplication \*
Division \/
Module \%
Assignment \=

Smaller \<
Smaller_Equal \<\=
Bigger \>
Bigger_Equal \>\=
Equal \=\=
Not_Equal \!\=
Relational {Smaller}|{Smaller_Equal}|{Bigger}|{Bigger_Equal}|{Equal}|{Not_Equal}

AND \&\&
OR \|\|
NOT \!
Logical {AND}|{OR}|{NOT}

Operator {Addition}|{Subtraction}|{Multiplication}|{Division}|{Module}|{Assignment}|{Relational}|{Logical}

/* Keyword */
Keyword boolean|break|byte|case|char|catch|class|const|continue|default|do|double|else|extends|false|final|finally|float|for|if|implements|int|long|new|private|protected|public|return|short|static|string|switch|this|true|try|void|while



/* Symbols of Number */
Dot \.
Sign \+|\-
Digit [0-9]
Exponent E|e

/* Integer */
Unsign_Integer {Digit}+
Integer {Sign}?{Digit}+

/* Float */
Float {Integer}{Dot}{Unsign_Integer}
Scientific_Float {Float}{Exponent}{Integer}



/* Symbol of character */
Single_Quote \'

/* Character */
Character {Single_Quote}(\\[nrtbfv0]|[^\\]){Single_Quote}


/* Symbol of String */
BackSlash \\
Double_Quote \"
Specific_String_Symbol \\n|\\r|\\t|\\b|\\f|\\v|\\0|\\\"

/* String */
String_with_Quote {Double_Quote}(?:[^\"]|{Specific_String_Symbol})*{Double_Quote}



/* Symbol of Comment */
Double_Slash \/\/
Slash \/
Star \*
SlashStar {Slash}{Star}
StarSlash {Star}{Slash}

/* Comment */
Comment_C {SlashStar}(.|{NewLine})*{StarSlash}
Comment_CPP {Double_Slash}.*




/* Discard Token */
DeleteToken [\t\ ]
ErrorToken [^\,\:\;\(\)\[\]\{\}\+\-\*\/\%\=\<\>\!\&\|\ \r\n\t]+

/* Symbols of Identifiers */
Uppercase [A-Z]
Lowercase [a-z]
LegalSign [\_\$]
Alphabat {Uppercase}|{Lowercase}
IdentifierHeader {LegalSign}|{Alphabat}
IdentifierLetter {IdentifierHeader}|{Digit}

/* Identifiers */
Identifier {IdentifierHeader}+{IdentifierLetter}*

%%

{DeleteToken} {
    CharPos += yyleng;
}

{NewLine} {
    ++Lines;
    CharPos = 1;
}

{Comment_C} {
    char c, temp;
    int err = 0;
    printf("Line: %lli, 1st char: %lli, \"%s\" is a \"comment\".\n", Lines, CharPos, yytext);
    Lines += yylineno;
}

{Comment_CPP} {
    printf("Line: %lli, 1st char: %lli, \"%s\" is a \"comment\".\n", Lines, CharPos, yytext);
    CharPos += yyleng;
}

{Symbol} {
    printf("Line: %lli, 1st char: %lli, \"%s\" is a \"symbol\".\n", Lines, CharPos, yytext);
    CharPos += yyleng;
}

{Operator} {
    printf("Line: %lli, 1st char: %lli, \"%s\" is a \"operator\".\n", Lines, CharPos, yytext);
    CharPos += yyleng;
}

{Keyword} {
    printf("Line: %lli, 1st char: %lli, \"%s\" is a \"reserved word\".\n", Lines, CharPos, yytext);
    CharPos += yyleng;
}

{Character} {
    printf("Line: %lli, 1st char: %lli, \"%s\" is a \"character\".\n", Lines, CharPos, yytext);
    CharPos += yyleng;
}

{Float}|{Scientific_Float} {
    printf("Line: %lli, 1st char: %lli, \"%s\" is a \"real\".\n", Lines, CharPos, yytext);
    CharPos += yyleng;
}

{Integer} {
    printf("Line: %lli, 1st char: %lli, \"%s\" is a \"Integer\".\n", Lines, CharPos, yytext);
    CharPos += yyleng;
}

{String_with_Quote} {
    char* tmp = malloc(sizeof(char) * yyleng);
    ++CharPos;
    printf("Line: %lli, 1st char: %lli, \"", Lines, CharPos);
    char t;
    int i, j;
    for (i = 1; i < yyleng - 1; ++i) {
        if (yytext[i] == '\\') {
            ++i;
            t = yytext[i];
            switch(t) {
            case 'n':
                tmp[j] = '\n';
                break;
            case 'r':
                tmp[j] = '\r';
                break;
            case 't':
                tmp[j] = '\t';
                break;
            case 'b':
                tmp[j] = '\b';
                break;
            case 'f':
                tmp[j] = '\f';
                break;
            case 'v':
                tmp[j] = '\v';
                break;
            case '0':
                tmp[j] = '\0';
                break;
            case '\'':
            case '\"':
            case '\\':
                tmp[j] = yytext[i];
                break;
            default:
                tmp[j] = '\\';
                ++j;
                tmp[j] = yytext[i];
                break;
            }
            ++j;
        }
        tmp[j] = yytext[i];
        ++j;
    }
    tmp[j] = '\0';
    printf("%s\" is a \"string\".\n", tmp);
    CharPos += yyleng - 1;
}


{Identifier} {
    insert(yytext);
    printf("Line: %lli, 1st char: %lli, \"%s\" is a \"ID\".\n", Lines, CharPos, yytext);
    CharPos += yyleng;
}

{ErrorToken} {
    printf("Line: %lli, 1st char: %lli, \"%s\" is an \"error\".\n", Lines, CharPos, yytext);
    CharPos += yyleng;
}

%%
//usr code
main() {
    create();
    yylex();
    dump();
    return 0;
}