class TreeSitterPython < Formula
  desc "Python grammar for tree-sitter"
  homepage "https://github.com/tree-sitter/tree-sitter-python"
  url "https://github.com/tree-sitter/tree-sitter-python/releases/download/v0.25.0/tree-sitter-python.tar.gz"
  sha256 "7bce887eb2f33e94bf74a69645cf5138d4096720e54fd3269a6124c06b93c584"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3a60a36c4e9b2ed51a22ff5d9bbfb3e2a5f53494c21aad0770fef53c43adad02"
    sha256 cellar: :any,                 arm64_sequoia: "6dc2beff65e9fc9defc633cdfbc430ea07fa6f2f5f7a156db1b5c2460ae653e2"
    sha256 cellar: :any,                 arm64_sonoma:  "fc8ac5e436d8248faa633d23b40f69005cce2e705e4c10ca2b48a1bde9214c68"
    sha256 cellar: :any,                 sonoma:        "c3572f7a1ecb1de67730874338dfa824f473a901e44bef2ab8939889c8bb897b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0761d91e13e6dd90d04ec5762a50e96473cf6d0ee001a13c39e04cc012a42cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14d4bbe53d84b5ff5d56ba415dfcde122cfcac34dc2670527e46b73d6623672d"
  end

  depends_on "tree-sitter" => :test

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <string.h>
      #include <stdio.h>
      #include <tree_sitter/api.h>

      const TSLanguage *tree_sitter_python(void);

      int main() {
        TSParser *parser = ts_parser_new();
        ts_parser_set_language(parser, tree_sitter_python());

        const char *source_code = "42";
        TSTree *tree = ts_parser_parse_string(
          parser,
          NULL,
          source_code,
          strlen(source_code)
        );

        TSNode root_node = ts_tree_root_node(tree);
        char *string = ts_node_string(root_node);
        printf("%s\\n", string);

        free(string);
        ts_tree_delete(tree);
        ts_parser_delete(parser);
        return 0;
      }
    C
    system ENV.cc, "test.c",
                   "-I#{include}", "-I#{Formula["tree-sitter"].opt_include}",
                   "-L#{lib}", "-L#{Formula["tree-sitter"].opt_lib}",
                   "-ltree-sitter", "-ltree-sitter-python",
                   "-o", "test"
    expected = "(module (expression_statement (integer)))"
    assert_equal expected, shell_output(testpath/"test").strip
  end
end
