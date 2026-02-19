class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.5.tar.gz"
  sha256 "8e012493b2103e0471d3aba8048b73bc1a3138132974e2fd8bfb89a63e62f478"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0af4d4b6d239133dbf53f1b666448d89c6b1e7de2083f140e70473bd9957658b"
    sha256 cellar: :any,                 arm64_sequoia: "ad99138158db223f367412b2c03bc613e29dde67cc00fd89c5a6ace2a83b41c3"
    sha256 cellar: :any,                 arm64_sonoma:  "b89d47b1af9429d76bea00252a062994bc29f9380cbedbcbeb952170ccd040e1"
    sha256 cellar: :any,                 sonoma:        "d39575eb2e6412e5631f13c4ee199cb911d5bed31aece69db4c43828eeaf286f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d17e9e0faf8106187ab5b603b81f9525834c19d6b1d24937edec2410ae074783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8eb22984decfe950f5c4a156cab5e2d8d271327696c7b7babebe987aebf8bf8"
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
