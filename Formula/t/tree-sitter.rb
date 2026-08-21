class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.12.tar.gz"
  sha256 "428e2b182fe38eddc100d8bd851e47c96921a69281b66abafc25ba4b0aaeeeab"
  license "MIT"
  compatibility_version 1
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "80d16fc3dc8a354225de3bf1eea82365a76ad5b08592780faf31b1035147719c"
    sha256 cellar: :any, arm64_sequoia: "de0700ba2202f2dd9b9a19c50074dd7bd17856d853a916b8addbc50bb51c1c81"
    sha256 cellar: :any, arm64_sonoma:  "d2ac6adb3eb123526ada5b3f6be351730aa5f8acc41172eccbabe410c80e8ed9"
    sha256 cellar: :any, sonoma:        "4064e313ca0f70b97cf3268a5ab55004b74c3649df0af4043547b0debaddd9ce"
    sha256 cellar: :any, arm64_linux:   "a127b003c78351c85bcb466846c72923e5997fb97f426c3504f251e18a8de884"
    sha256 cellar: :any, x86_64_linux:  "05ff81adff3c4950a76674f94135ce9674103b9eb8092864a692ab9528be6e58"
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
