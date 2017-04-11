%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "HT.h"
    typedef unsigned long long int ulli;
    ulli Lines = 1;
    ulli CharsAtLine = 1;
%}

/* Others */
NewLineCRLF \r\n
NewLineLF \n
NewLine {NewLineCRLF}|{NewLineLF}
WhiteSpace [ ]
Tabs \t

/* Symbols */
Comma \,
Colon \:
Semicolon \;
ParentheseLeft \(
ParentheseRight \)
SquareBracketsLeft \[
SquareBracketsRight \]
BracketLeft \{
BracketRight \}
Symbols {Comma}|{Colon}|{Semicolon}|{ParentheseLeft}|{ParentheseRight}|{SquareBracketsLeft}|{SquareBracketsRight}|{BracketLeft}|{BracketRight}

/* Arithmetic, Relational, and Logical Operators */
Operators2 \+|\-|\*|\/|\%|\=|\<|\<\=|\>\=|\>|\=\=|\!\=|\&\&|\|\||\!
Operators1 \+\+|\-\-
Operators {Operators2}|{Operators1}

/* Keywords */
Keywords boolean|break|byte|case|char|catch|class|const|continue|default|do|double|else|extends|false|final|finally|float|for|if|implements|int|long|new|private|protected|public|return|short|static|string|switch|this|true|try|void|while

/* Symbols of Number */
Digit [0-9]
Signs [\+\-]
Dot \.
E e|E

/* Integer */
UnsignedInteger {Digit}+
Integer {Signs}?{Digit}+

/* Float */
Float {Integer}{Dot}{UnsignedInteger}
ScientistFloat {Float}{E}{Integer}

/* Symbols of String */
Quote \"
BackSlash \\
EscapeCharactersWithLetter \\n|\\r|\\t|\\b|\\f|\\v|\\0

/* String */
StringWithQuote {Quote}(?:[^\"\\\r\n]|{EscapeCharactersWithLetter})*{Quote}
StringOrEmpty .*

/* Symbols of Comments */
DoubleSlash \/\/
Slash \/
Star \*
SlashStar {Slash}{Star}
StarSlash {Star}{Slash}

/* Comments */
CommentCStyle {SlashStar}
CommentCPPStyle {DoubleSlash}{StringOrEmpty}

/* Delete, Error Token */
DeleteToken [\t\ ]
ErrorToken [^\,\:\;\(\)\[\]\{\}\+\-\*\/\%\=\<\>\!\&\|\ \r\n\t]+

/* Symbols of Identifiers */
UpperAtoZ [A-Z]
LowerAtoZ [a-z]
ISigns [\_\$]
EnglishLetters {UpperAtoZ}|{LowerAtoZ}
IdentifierHeadSigns {ISigns}|{EnglishLetters}
IdentifierTailSigns {IdentifierHeadSigns}|{Digit}

/* Identifiers */
Identifier {IdentifierHeadSigns}+{IdentifierTailSigns}*

%%

{DeleteToken} {
    CharsAtLine += yyleng;
}

{NewLine} {
    ++Lines;
    CharsAtLine = 1;
}

{CommentCStyle} {
    int c1 = 0, c2 = input(), check = 1;
    printf("Line: %lli, 1st char: %lli, \"%s", Lines, CharsAtLine, yytext);
    CharsAtLine += yyleng;
    for (;;) {
        if (c2 == EOF) {
            check = 0;
            break;
        } else if (c2 == '\n') {
            ++Lines;
            CharsAtLine = 1;
        }
        c1 = c2;
        c2 = input();
        ++CharsAtLine;
        printf("%c", c1);
        if (c1 == '*' && c2 =='/') {
            printf("/");
            ++CharsAtLine;
            break;
        }
    }
    if (!check) {
        printf("\" is an \"error\".\n");
    } else {
        printf("\" is a \"comment\".\n");
    }
}

{CommentCPPStyle} {
    printf("Line: %lli, 1st char: %lli, \"%s\" is a \"comment\".\n", Lines, CharsAtLine, yytext);
    CharsAtLine += yyleng;
}

{Symbols} {
    printf("Line: %lli, 1st char: %lli, \"%s\" is a \"symbol\".\n", Lines, CharsAtLine, yytext);
    CharsAtLine += yyleng;
}

{Operators} {
    printf("Line: %lli, 1st char: %lli, \"%s\" is a \"operator\".\n", Lines, CharsAtLine, yytext);
    CharsAtLine += yyleng;
}

{Keywords} {
    printf("Line: %lli, 1st char: %lli, \"%s\" is a \"reserved word\".\n", Lines, CharsAtLine, yytext);
    CharsAtLine += yyleng;
}

{Float}|{ScientistFloat} {
    printf("Line: %lli, 1st char: %lli, \"%s\" is a \"real\".\n", Lines, CharsAtLine, yytext);
    CharsAtLine += yyleng;
}

{Integer} {
    printf("Line: %lli, 1st char: %lli, \"%s\" is a \"Integer\".\n", Lines, CharsAtLine, yytext);
    CharsAtLine += yyleng;
}

{StringWithQuote} {
    char* tmp = malloc(sizeof(char) * yyleng);
    ++CharsAtLine;
    printf("Line: %lli, 1st char: %lli, \"", Lines, CharsAtLine);
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
    CharsAtLine += yyleng - 1;
}

{Identifier} {
    Insert(yytext);
    printf("Line: %lli, 1st char: %lli, \"%s\" is a \"ID\".\n", Lines, CharsAtLine, yytext);
    CharsAtLine += yyleng;
}

{ErrorToken} {
    printf("Line: %lli, 1st char: %lli, \"%s\" is an \"error\".\n", Lines, CharsAtLine, yytext);
    CharsAtLine += yyleng;
}

%%

int main () {
    Create();
    yylex();
    Dump();
    return 0;
}