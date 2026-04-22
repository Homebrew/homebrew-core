class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.8.tar.gz"
  sha256 "e6826b7533ec3a885aba598377a6d20b5a6321ff3db76968e960c2352d3a5077"
  license "MIT"
  compatibility_version 1
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b84a34a7503d55b4a6c9a41d9ee014cd46c1683482d1529a4ba39ca005455f8"
    sha256 cellar: :any,                 arm64_sequoia: "67064145858e934d849ed6ff66fea03d542ea1138d836de57614e012c6670938"
    sha256 cellar: :any,                 arm64_sonoma:  "8d5e9c4a7761ed99f1282abb821b3203d8140f2b11befac93ce6741f7dbd7b2b"
    sha256 cellar: :any,                 sonoma:        "41767f3b5b96222571b9bcb2b8bbb8036a9e00f2f609c2f38993f2e1af6a27a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ac13abe298720b57758408a01085ceaa69314dc01d574e5b55dcb041f6a4853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d491ffcccdcad3004b01226f7a2ea8348f598bbd6a55aebdf83e76272644086e"
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
