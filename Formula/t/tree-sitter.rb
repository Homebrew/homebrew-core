class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.11.tar.gz"
  sha256 "1bab01ed21464f3272665b9c60e39ee79f68da1333e80b23f2c9356569d06971"
  license "MIT"
  compatibility_version 1
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "137a01078d02208df01f6dd460ae2a1765b54a614e2b0103200225959a0a0659"
    sha256 cellar: :any, arm64_sequoia: "ceb2da3c4a3fab204a477f19e6315d86d8aab6a39a264bb76ec4a02c82f542be"
    sha256 cellar: :any, arm64_sonoma:  "5276154fbf0bfab19c9f9119a5fedf160a2609daa26eb9ea94aacfc634c7b91a"
    sha256 cellar: :any, sonoma:        "76999dc6703c3ce0ef21bd049ce4d315ef4eea0de4eba0cda5c138d87a1a906b"
    sha256 cellar: :any, arm64_linux:   "6bf6ad4f1b4ce6945bbef8f727c7fc6e0af3772dfd93538b3894a7f8042d6f90"
    sha256 cellar: :any, x86_64_linux:  "1edf8e3292e58c62736a64d7bb2e9ab5ece996b7668e8584bc32528ec068ff21"
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
