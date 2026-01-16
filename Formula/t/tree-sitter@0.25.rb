class TreeSitterAT025 < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.25.10.tar.gz"
  sha256 "ad5040537537012b16ef6e1210a572b927c7cdc2b99d1ee88d44a7dcdc3ff44c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(0\.25(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8768100aef39bb857dd027746285ab4de42f2e109b729823293ac651268a3405"
    sha256 cellar: :any,                 arm64_sequoia: "e4fb44830a89485b29db99ef123987d4f7695d731b72151bd5e4ef9952e2d4f9"
    sha256 cellar: :any,                 arm64_sonoma:  "fb13239c0da50c5d2383d99704b80449e86dead3f089698e34813eb958c33850"
    sha256 cellar: :any,                 sonoma:        "9ec1aa4a91c20b0693207a95136afb902e11b27d152df2e484ec5cb2b27a69c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92c10305824b1813976f9ed542e9fee4e040fd093a396d7f03dd103b46f7c8bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2755f015c219318a8c7173c338439c7431402e04690b17e4b6d2f255ab424c84"
  end

  keg_only :versioned_formula

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
    system ENV.cc, "-I#{include}", "test_program.c", "-L#{lib}", "-ltree-sitter", "-o", "test_program"
    assert_equal "tree creation failed", shell_output("./test_program")
  end
end
