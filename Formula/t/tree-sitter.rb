class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.10.tar.gz"
  sha256 "450cb85fd1af34111eb162e931e0e9e4d4dbf23fc09b9cb56f6299a1a80483b6"
  license "MIT"
  compatibility_version 1
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "12da281322989a74a019c6b9d091b5e96dfd624baf8c413fd58a392acae6359b"
    sha256 cellar: :any, arm64_sequoia: "5d0949f138dcaefbfb1a53fa4ff792593afaafed90fdc43c08e626ddf4c8ee11"
    sha256 cellar: :any, arm64_sonoma:  "de259b490a30662ad15596333d8993443b95a56a68a997cf4517abda6c07492a"
    sha256 cellar: :any, sonoma:        "272f5482cbd015087b0188c2c9a87326bb81401c3de52f57e9a0ef664e2d9fc8"
    sha256 cellar: :any, arm64_linux:   "86412764df701a4718506ad51eaccab1422cc72cca5b12a23ff6ab49cc565a66"
    sha256 cellar: :any, x86_64_linux:  "5641cb09c3d737be20b7900b5901f89d8098754a8a8b502b8063f3164fa755a1"
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
