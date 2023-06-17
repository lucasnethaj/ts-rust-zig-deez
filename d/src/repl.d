module repl;

import std.stdio;
import token;
import lexer;

enum PROMPT = ">> ";

void start(File inFile, File outFile) {
    while (true) {
        outFile.write(PROMPT);
        string line = inFile.readln();
        if (line == null) {
            break;
        }

        Lexer lexer = Lexer(line);
        Token tok;

        while (tok.type != TokenType.EOF) {
            tok = lexer.nextToken();
            outFile.writeln(tok);
        }

    }
}
    
