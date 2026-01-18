class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "7f4a7cf0a2cd217444063fe2a4d800bc9d21ed609badc2ac20c0841d67166550"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a9814378eff0b42340bbff075c6e52b68dfb29edc6f0b264334809b02eedffbc"
    sha256 cellar: :any,                 arm64_sequoia: "40213cc22c7b17e0d7265b72af2bf1c650203ea5379b3e91f5debb46c1104058"
    sha256 cellar: :any,                 arm64_sonoma:  "e7ddb00fbb96876e17b73e7765f54bdf63104821d5656ae6cd4913f40540e25d"
    sha256 cellar: :any,                 sonoma:        "426074ecd8fee3c336468daf48958a638274eecd0b305ff13d4bb11ef4ae82d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01ae81da74c8f8f3b3cbcf3641e2a25a813987500ec42eaba0a44ca001320b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9c21b563ee81bbe684db5743a5b6f4245ba7cf81c5102fb40d3c2dde3ea8add"
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
