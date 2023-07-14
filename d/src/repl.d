module repl;

import std.stdio;
import token;
import lexer;

enum PROMPT = ">> ";

@safe:

void start(File inFile, File outFile)
{
    outFile.write(PROMPT);

    char[1024] buf;
    string text;

    for (;;) {
        const read_buffer = inFile.rawRead(buf);
        if (read_buffer.length is 0) {
            break;
        }
        text ~= read_buffer;
    }

    Lexer lexer = Lexer(text);
    Token tok;


    // while (tok.type != TokenType.EOF)
    // {
    //     tok = lexer.nextToken();
    //     outFile.writeln(tok);
    // }

    auto _lexer = Lexer(text);
    foreach(_tok; _lexer) {
        outFile.writeln(_tok);
    }

}
