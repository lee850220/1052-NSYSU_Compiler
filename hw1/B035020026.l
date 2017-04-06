%{
//Definition

%}

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


%%




%%
//usr code
main() {
    create();
    yylex();
    dump();


}