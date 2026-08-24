class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.13.tar.gz"
  sha256 "ece24c3c5e2a76384075e830c7139b59fce8fb01e4ef8436fab08bbe10444c89"
  license "MIT"
  compatibility_version 1
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1b2e6621d2ea2e1ccf30653ade30fd1bf5b16772e9812bf19d7039366186ec00"
    sha256 cellar: :any, arm64_sequoia: "dff993ef75d7d8a729c67f5d63a1b5c8a309f495985a9ff32114bf56e825310d"
    sha256 cellar: :any, arm64_sonoma:  "5ee26a0b75c4d76e0abeeb2efe1e15873c4540bb5ac0a7c6d03c40e2dd9c0c87"
    sha256 cellar: :any, sonoma:        "c128eb45623eea6e91083d8f5292d05e9dc1a5a6a94311315b2e18f1111aedfa"
    sha256 cellar: :any, arm64_linux:   "daebe9449b991a1b8812c239a2437bd1357323d891cbdbe60d33558a44e13e2b"
    sha256 cellar: :any, x86_64_linux:  "a474f12167e395fff07f7f2443ce1c531b2796d6aedd557f7b25df349be20c9d"
  end

  def install
    system "make", "install", "AMALGAMATED=1", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      This formula now installs only the `tree-sitter` library (`libtree-sitter`).
      To install the CLI tool:
        brew install tree-sitter-cli
    EOS
  end

  test do
    (testpath/"test_program.c").write <<~C
      #include <stdio.h>
      #include <string.h>
      #include <tree_sitter/api.h>
      int main(int argc, char* argv[]) {
        TSParser *parser = ts_parser_new();
        if (parser == NULL) {
          return 1;
        }
        // Because we have no language libraries installed, we cannot
        // actually parse a string successfully. But, we can verify
        // that it can at least be attempted.
        const char *source_code = "empty";
        TSTree *tree = ts_parser_parse_string(
          parser,
          NULL,
          source_code,
          strlen(source_code)
        );
        if (tree == NULL) {
          printf("tree creation failed");
        }
        ts_tree_delete(tree);
        ts_parser_delete(parser);
        return 0;
      }
    C
    system ENV.cc, "test_program.c", "-L#{lib}", "-ltree-sitter", "-o", "test_program"
    assert_equal "tree creation failed", shell_output("./test_program")
  end
end
