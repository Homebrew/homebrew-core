class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "d35c96e68736bd9569d2757c3cc71052485f33082c3825f1aed9d0e86013a159"
  license "MIT"
  compatibility_version 2
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ff0098f48b925db032e847bef0144561b1b20f7ddd89cb8be29619d714a8fc5a"
    sha256 cellar: :any, arm64_tahoe:       "2789c65bfe825817f535e1eb614c1a011433a7b32d3eae850668d136a02e6cbf"
    sha256 cellar: :any, arm64_sequoia:     "3d994420b9b2bcd2bb27159e95b3551944f52f124982e534dbc5e3ce7aa2b05c"
    sha256 cellar: :any, arm64_sonoma:      "c0ad6b5d40e2b57df673674f19243f74ac66bb1308660aa278c36a9419d41c22"
    sha256 cellar: :any, arm64_linux:       "eaa32471c1d5780536b7fc65dbcd7bc69354de839f65ef8b39874b0f7b0f05ea"
    sha256 cellar: :any, x86_64_linux:      "9fca3679e71eb816f866ac9c2f818175f5325d031dd0bae6f6bd564bde06cfe8"
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
