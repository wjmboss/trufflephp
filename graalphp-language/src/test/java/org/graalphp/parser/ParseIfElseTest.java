package org.graalphp.parser;

import org.eclipse.php.core.PHPVersion;
import org.eclipse.php.core.ast.error.BailoutErrorListener;
import org.eclipse.php.core.ast.error.ConsoleErrorListener;
import org.eclipse.php.core.ast.nodes.ASTParser;
import org.eclipse.php.core.ast.nodes.Program;
import org.graalphp.nodes.PhpStmtNode;
import org.junit.Assert;
import org.junit.Test;

/**
 * @author abertschi
 */
public class ParseIfElseTest {

    @Test
    public void testParsing() throws Exception {
//        String src = TestCommons.php("if (1) {return 1;} return 2;");
        String src = TestCommons.php("if (10 + 1) { return 1; } return 3;");
        System.out.println(src);
        ASTParser parser = ASTParser.newParser(PHPVersion.PHP7_4);
        parser.setSource(src.toCharArray());
        parser.addErrorListener(new ConsoleErrorListener());
        parser.addErrorListener(new BailoutErrorListener());
        Program pgm = parser.parsePhpProgram();
        System.out.println(pgm);
        StmtVisitor visitor = new StmtVisitor(null);
        StmtVisitor.StmtVisitorContext phpAst = visitor.createPhpAst(pgm, ParseScope.newGlobalScope());
        for(PhpStmtNode s: phpAst.getStmts()) {
            System.out.println(s.toString());
        }

        Assert.assertTrue(phpAst.getStmts().size() > 0);
    }

    @Test
    public void testIfSimple() throws Exception {
        TestCommons.evalInteger(2, "if (false) { return 1; } return 2;");
        TestCommons.evalInteger(1, "if (1) { return 1; } return 2;");
        TestCommons.evalInteger(2, "if (0) { return 1; } return 2;");
        TestCommons.evalInteger(1, "if (1) { return 1; } else { return 2;} return 3;");
        TestCommons.evalInteger(2, "if (0) { return 1; } else { return 2;} return 3;");
    }

    @Test
    public void testArbitraryNumbers() throws Exception {
        TestCommons.evalInteger(1, "if (10 + 1) { return 1; } return 3;");
    }
}
