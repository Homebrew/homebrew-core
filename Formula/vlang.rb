class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/0.1.18.tar.gz"
  sha256 "3f3407a78aca7fc3b42a3fc1f1d2b9724c1e4c71fbd5d37ff12976cd2305cec1"

  def install
    system "make"
  end

  test do
    # test version CLI command
    version_output = shell_output("#{bin}/v -v")
    assert_match version.to_s, version_output

    # test help CLI command
    help_output = shell_output("#{bin}/v -h")
    assert_match "Usage: v [options] [file | directory]", help_output
    assert_match "Options:", help_output
    assert_match "-                 Read from stdin (Default; Interactive mode if in a tty)", help_output
    assert_match "-h, help          Display this information.", help_output
    assert_match "-v, version       Display compiler version.", help_output
    assert_match "-prod             Build an optimized executable.", help_output
    assert_match "-o <file>         Place output into <file>.", help_output
    assert_match "-obf              Obfuscate the resulting binary.", help_output
    assert_match "-show_c_cmd       Print the full C compilation command and how much time it took.", help_output
    assert_match "-debug            Leave a C file for debugging in .program.c.", help_output
    assert_match "-live             Enable hot code reloading (required by functions marked with [live]).", help_output
    assert_match "fmt               Run vfmt to format the source code.", help_output
    assert_match "up                Update V.", help_output
    assert_match "run               Build and execute a V program. You can add arguments after the file name.", help_output
    assert_match "build module      Compile a module into an object file.", help_output
  end
end
