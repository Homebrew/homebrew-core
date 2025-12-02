class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.25.10.tar.gz"
  sha256 "ad5040537537012b16ef6e1210a572b927c7cdc2b99d1ee88d44a7dcdc3ff44c"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f9a598017206ce74d26f36092de8a18e28a5dcc78afba03853a248c46ab5998"
    sha256 cellar: :any,                 arm64_sequoia: "6296ee2587853fcf55e33195b48366eba0757577b64364e4e71cb84fccd83dfc"
    sha256 cellar: :any,                 arm64_sonoma:  "62123823b2664ffd87749f9efb3b3f63e87e0e454e373b17bce056f3fbf4a1f9"
    sha256 cellar: :any,                 sonoma:        "ce78af5bcfc0e9319e3df5149b39371543ac7d58d6de67e3f0c10c8eb7a41bb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c41c7235ba0dac5544cc6360090d51ecb07b5e977a31c602d98793ece3fccf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a292ee5d00c1c04db4d8083f6dcd8b70807d83cf9d97cc1764a492e4c588fd5"
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
