class TreeSitterGo < Formula
  desc "Go grammar for tree-sitter"
  homepage "https://github.com/tree-sitter/tree-sitter-go"
  url "https://github.com/tree-sitter/tree-sitter-go/releases/download/v0.25.0/tree-sitter-go.tar.gz"
  sha256 "ac412018d59f7cd5bb72fbde557e9ebf9fdfac12c5853f2bb03669f980a953bb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "abb2cdf96e2e7a44bceb1db0e97650d6574f514366061804a97d59f8e76d106f"
    sha256 cellar: :any,                 arm64_sequoia: "7d424b01e2607f8ab843a09e12adb43b39944e405d53e8350b5d029d1aab1309"
    sha256 cellar: :any,                 arm64_sonoma:  "d3367a53722b14f26fd7ca46f27dd43734119ba176c638de58d27814eb03e35c"
    sha256 cellar: :any,                 sonoma:        "3f77f949e6eccdd23929f26f3bc312e305a40690512cf2acab7e0738415dcbea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b95354230f025f212371d330dab2b6e7fcf1b5d53a1e61fd6df72d375606db59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f1c8eac835b1e9313c0ec544ce9d21809aeb22700df31cb80725c3f584f9858"
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

      const TSLanguage *tree_sitter_go(void);

      int main() {
        TSParser *parser = ts_parser_new();
        ts_parser_set_language(parser, tree_sitter_go());

        const char *source_code = "package main\\nimport \\"fmt\\"\\nfunc main() { fmt.Println(\\"Hello, World!\\") }";
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
                   "-ltree-sitter", "-ltree-sitter-go",
                   "-o", "test"
    expected = "(source_file (package_clause (package_identifier)) (import_declaration (import_spec path:" \
               "(interpreted_string_literal (interpreted_string_literal_content)))) (function_declaration name:" \
               "(identifier) parameters: (parameter_list) body: (block (statement_list (expression_statement" \
               "(call_expression function: (selector_expression operand: (identifier) field: (field_identifier))" \
               "arguments: (argument_list (interpreted_string_literal (interpreted_string_literal_content)))))))))"
    assert_equal expected.gsub(/\s+/, "").strip,
                 shell_output(testpath/"test").gsub(/\s+/, "").strip
  end
end
