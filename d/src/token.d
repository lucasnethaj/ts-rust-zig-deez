module token;
import std.conv;
import std.typecons;
import std.traits;
import std.range;
import std.algorithm;


@safe:
@nogc:
nothrow:
pure:

struct Token
{
    TokenType type;
    string literal;

    this(TokenType type, string literal)
    {
        this.type = type;
        this.literal = literal;
    }

    this(TokenType type, char literal)
    {
        this.type = type;
        this.literal = literal.to!string;
    }
}

enum TokenType
{
    ILLEGAL = "ILLEGAL",
    EOF = "EOF",

    // Identifiers + literals
    IDENT = "IDENT", // add, foobar, x, y, ...
    INT = "INT", // 1343456

    // Operators
    ASSIGN = "=",
    PLUS = "+",
    MINUS = "-",
    BANG = "!",
    ASTERISK = "*",
    SLASH = "/",

    LT = "<",
    GT = ">",

    EQ = "==",
    NOT_EQ = "!=",

    COMMA = ",",
    SEMICOLON = ";",

    LPAREN = "(",
    RPAREN = ")",
    LBRACE = "{",
    RBRACE = "}",

    // Keywords
    FUNCTION = "FUNCTION",
    LET = "LET",
    TRUE = "TRUE",
    FALSE = "FALSE",
    IF = "IF",
    ELSE = "ELSE",
    RETURN = "RETURN",
}

private alias TT = const(TokenType);

// immutable TokenType[string] keywords = [
//     "fn": TT.FUNCTION, "let": TT.LET, "true": TT.TRUE, "false": TT.FALSE,
//     "if": TT.IF, "else": TT.ELSE, "return": TT.RETURN,
// ];
import std.typecons;

immutable keywords = [
    tuple("fn", TT.FUNCTION), 
    tuple("let", TT.LET), 
    tuple("true", TT.TRUE), 
    tuple("false", TT.FALSE),
    tuple("if", TT.IF), 
    tuple("else", TT.ELSE), 
    tuple("return", TT.RETURN),
];

const(TokenType) lookupIdent(string ident) 
{
    auto lookup = keywords.find!(keyword => keyword[0] == ident);

    if (lookup.empty) 
    {
        return TT.IDENT;
    }
    return lookup.front[1];
}
