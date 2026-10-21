class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "982cd3d4d9eb7be18c243240a622423fd2e4ecb4bec2cd98832c2f3fa1f0f333"
  license "MIT"
  compatibility_version 2
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c42e8f765aedd344347abdbae7fa65e11e07905b07f2cb24d63a19597fff62f2"
    sha256 cellar: :any, arm64_tahoe:       "548826203ea63bf6cf46386caa142896c273b979bf5f171b9c0739832384e4ba"
    sha256 cellar: :any, arm64_sequoia:     "05daa0f8c14b857fb4667baef829f66a625e0edbd12540df7ee5588676fdf0ea"
    sha256 cellar: :any, arm64_linux:       "15bac04f90612b0f464de201f74ef4e59845aa30c0f2bef5bb7f41964595719e"
    sha256 cellar: :any, x86_64_linux:      "45167e295ff8118f3806f0f8860e43d79c0b6d1e7d7c64468badb2984136a71a"
  end

  deny_network_access!

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
