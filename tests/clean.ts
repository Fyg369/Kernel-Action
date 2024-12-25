import * as fs from 'fs';
import { execSync } from 'child_process';

const fileExist = fs.existsSync("./.git");
const T = fs.existsSync("./tests");

if (fileExist) {
    try {
        execSync("git clean -dxf");
        execSync("git checkout .");
    } catch (error) {
        console.error("Error executing git commands:", error);
    }
} else {
    if (T) {
        try {
            fs.unlinkSync("tests/yarn.lock");
            fs.unlinkSync("tests/patch.sh");
            fs.unlinkSync("tests/shfmt");
            fs.rmdirSync("tests/node_modules", { recursive: true });
        } catch (error) {
            console.error("Error handling files or directories:", error);
        }
    }
}
