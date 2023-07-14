module lexer;

import std.format;
import std.stdio : writeln;
import std.ascii : isAlpha, isDigit;
import std.meta;
import token;

@safe:


struct Lexer
{
    string input;
    size_t position;
    size_t readPosition;
    char ch;
    Token current_token;

    this(string input)
    {
        this.input = input;
        readChar;
        popFront;
    }


    

    
    Token nextToken()
    {
        Token tok;
        skipWhiteSpace;

        TokenCase:
        switch (ch) with (TokenType)
        {

        static foreach(TOKEN_TYPE; AliasSeq!(
                SEMICOLON,
                LPAREN,
                RPAREN,
                COMMA,
                PLUS,
                LBRACE,
                RBRACE,
                LT,
                GT,
                ASTERISK,
                MINUS,
                SLASH, 
            )
        ) {
            static assert(TOKEN_TYPE.length is 1, "This token can only be one char");

            case TOKEN_TYPE[0]:
                tok = Token(TOKEN_TYPE, TOKEN_TYPE[0]);
                break TokenCase; 
        }
    
        case '=':
            if (peekChar == '=')
            {
                const ch = this.ch;
                readChar;
                tok = Token(EQ, [ch, this.ch]);
            }
            else
            {
                tok = Token(ASSIGN, ch);
            }
            break;

        case '!':
            if (peekChar == '=')
            {
                const ch = this.ch;
                readChar;
                tok = Token(NOT_EQ, [ch, this.ch]);
            }
            else
            {
                tok = Token(BANG, ch);
            }
            break;
        case 0:
            tok = Token(EOF, "");
            break;
        default:
            if (isLetter(ch))
            {
                tok.literal = readIdentifier;
                tok.type = lookupIdent(tok.literal);
                return tok;
            }
            else if (isDigit(ch))
            {
                tok.type = INT;
                tok.literal = readNumber;
                return tok;
            }
            else
            {
                tok = Token(ILLEGAL, ch);
            }
        }

        readChar;
        return tok;
    }


    bool empty() const pure {
        return readPosition > input.length;
    }
    void popFront() {
        current_token = nextToken;
    }

    const(Token) front() const pure {
        return current_token;
    }


    
    void readChar()
    {
        if (readPosition >= input.length)
        {
            ch = 0;
        }
        else
        {
            ch = input[readPosition];
        }
        position = readPosition;
        readPosition += 1;
    }

    string readNumber()
    {
        const beginPos = position;
        while (isDigit(ch))
        {
            readChar;
        }
        return input[beginPos .. position];
    }

    string readIdentifier()
    {
        const beginPos = position;
        while (isLetter(ch))
        {
            readChar;
        }
        return input[beginPos .. position];
    }

    char peekChar()
    {
        if (readPosition >= input.length)
        {
            return 0;
        }
        else
        {
            return input[readPosition];
        }
    }

    void skipWhiteSpace()
    {
        while (ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r')
        {
            readChar;
        }
    }
}


bool isLetter(const char ch) pure nothrow @nogc
{
    return isAlpha(ch) || ch == '_';
}




/// Monkey code test
unittest
{

    const input = `let five = 5;
let ten = 10;

let add = fn(x, y) {
  x + y;
};

let result = add(five, ten);
!-/*5;
5 < 10 > 5;

if (5 < 10) {
	return true;
} else {
	return false;
}

10 == 10;
10 != 9;`;

    Token[] tests = [
        Token(TokenType.LET, "let"), Token(TokenType.IDENT, "five"),
        Token(TokenType.ASSIGN, "="), Token(TokenType.INT, "5"),
        Token(TokenType.SEMICOLON, ";"), Token(TokenType.LET, "let"),
        Token(TokenType.IDENT, "ten"), Token(TokenType.ASSIGN, "="),
        Token(TokenType.INT, "10"), Token(TokenType.SEMICOLON, ";"),
        Token(TokenType.LET, "let"), Token(TokenType.IDENT, "add"),
        Token(TokenType.ASSIGN, "="), Token(TokenType.FUNCTION, "fn"),
        Token(TokenType.LPAREN, "("), Token(TokenType.IDENT, "x"),
        Token(TokenType.COMMA, ","), Token(TokenType.IDENT, "y"),
        Token(TokenType.RPAREN, ")"), Token(TokenType.LBRACE, "{"),
        Token(TokenType.IDENT, "x"), Token(TokenType.PLUS, "+"),
        Token(TokenType.IDENT, "y"), Token(TokenType.SEMICOLON, ";"),
        Token(TokenType.RBRACE, "}"), Token(TokenType.SEMICOLON, ";"),
        Token(TokenType.LET, "let"), Token(TokenType.IDENT, "result"),
        Token(TokenType.ASSIGN, "="), Token(TokenType.IDENT, "add"),
        Token(TokenType.LPAREN, "("), Token(TokenType.IDENT, "five"),
        Token(TokenType.COMMA, ","), Token(TokenType.IDENT, "ten"),
        Token(TokenType.RPAREN, ")"), Token(TokenType.SEMICOLON, ";"),
        Token(TokenType.BANG, "!"), Token(TokenType.MINUS, "-"),
        Token(TokenType.SLASH, "/"), Token(TokenType.ASTERISK, "*"),
        Token(TokenType.INT, "5"), Token(TokenType.SEMICOLON, ";"),
        Token(TokenType.INT, "5"), Token(TokenType.LT, "<"),
        Token(TokenType.INT, "10"), Token(TokenType.GT, ">"),
        Token(TokenType.INT, "5"), Token(TokenType.SEMICOLON, ";"),
        Token(TokenType.IF, "if"), Token(TokenType.LPAREN, "("),
        Token(TokenType.INT, "5"), Token(TokenType.LT, "<"),
        Token(TokenType.INT, "10"), Token(TokenType.RPAREN, ")"),
        Token(TokenType.LBRACE, "{"), Token(TokenType.RETURN, "return"),
        Token(TokenType.TRUE, "true"), Token(TokenType.SEMICOLON, ";"),
        Token(TokenType.RBRACE, "}"), Token(TokenType.ELSE, "else"),
        Token(TokenType.LBRACE, "{"), Token(TokenType.RETURN, "return"),
        Token(TokenType.FALSE, "false"), Token(TokenType.SEMICOLON, ";"),
        Token(TokenType.RBRACE, "}"), Token(TokenType.INT, "10"),
        Token(TokenType.EQ, "=="), Token(TokenType.INT, "10"),
        Token(TokenType.SEMICOLON, ";"), Token(TokenType.INT, "10"),
        Token(TokenType.NOT_EQ, "!="), Token(TokenType.INT, "9"),
        Token(TokenType.SEMICOLON, ";"), Token(TokenType.EOF, ""),
    ];

    Lexer l = Lexer(input);

    foreach (t; tests)
    {
        const tok = l.front();
        debug writeln(format("%s : %s", tok, t));

        assert(tok.type == t.type, format("Wrong token type '%s' expected '%s'", tok.type, t.type));
        assert(tok.literal == t.literal,
                format("Wrong literal '%s' expected '%s'", tok.literal, t.literal));
        l.popFront;
    }

}


