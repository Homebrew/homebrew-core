class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "356528363bf7fbad12a2cfeb5a2678c0118ef886a4d69ad9a379db5fdef0735f"
  license "MIT"
  compatibility_version 2
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a56600a706f2c5cbd1cc811029afb05d976af675f91a454b2835f8b2841753d4"
    sha256 cellar: :any, arm64_tahoe:       "3a04a0fb2dec9b4634f4ac6f09d5000474e11b50ee5cf6636d4dc8e1f401591a"
    sha256 cellar: :any, arm64_sequoia:     "8b0045cadd30ba785fcdad8c1f564ce31c9444541ff30e89d19291d4e90b65f5"
    sha256 cellar: :any, arm64_linux:       "758ad0ad98758c01de97c9693222cea8f35d7570df61a31c68ae93407dfc2f97"
    sha256 cellar: :any, x86_64_linux:      "ab4f10258eee1386d710007809acd397d8e7d34e0e5485897c5ab0b285613887"
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
