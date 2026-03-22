class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.7.tar.gz"
  sha256 "4343107ad1097a35e106092b79e5dd87027142c6fba5e4486b1d1d44d5499f84"
  license "MIT"
  compatibility_version 1
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2c52e8fb27ac173cf4a9afaa3d9ddac742f12b64efe525f4a402e326de0a3452"
    sha256 cellar: :any,                 arm64_sequoia: "43251440c6f503e676d5c5d1b2245f241de8f08e495963be0465ee27b8dfdf6b"
    sha256 cellar: :any,                 arm64_sonoma:  "49c03b1123f8afe223404199a5dc8a3e34082082714347f564b26d0d28dc007e"
    sha256 cellar: :any,                 sonoma:        "104641c45bfb93d0ed5ee8ea9fa2d1cacb49eb51ebd83d2935c79808527208a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95e48f32536caadfd23259deffe5ebc550c19de7acd228a9a8bb336bb5d57b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "260dacb180cd5dba770ccd4593774a68e6bd5e4ecee00c3df36ff12d9543396a"
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
