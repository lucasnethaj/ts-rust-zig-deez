module repl;

import std.stdio;
import token;
import lexer;

enum PROMPT = ">> ";

@safe:

void start(File inFile, File outFile)
{
    while (true)
    {
        outFile.write(PROMPT);
        string line = (() @trusted => inFile.readln())();
        if (line == null)
        {
            break;
        }

        Lexer lexer = Lexer(line);
        Token tok;

        while (tok.type != TokenType.EOF)
        {
            tok = lexer.nextToken();
            outFile.writeln(tok);
        }

    }
}
