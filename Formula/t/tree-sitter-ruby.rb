class TreeSitterRuby < Formula
  desc "Ruby grammar for tree-sitter"
  homepage "https://github.com/tree-sitter/tree-sitter-ruby"
  url "https://github.com/tree-sitter/tree-sitter-ruby/releases/download/v0.23.1/tree-sitter-ruby.tar.xz"
  sha256 "bf2ac68d0311f5e3b0859ef0748aafce5cfeb20b60c4b70b24707128abc12e00"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "394475b85b7a20b4a98422f2c7a39c7b76a0f0b2bfb185419a4dd18601f33d97"
    sha256 cellar: :any,                 arm64_sequoia: "c330f405d59e440333f38cc2a838112eb942ca80f3221ec91f85ec34495d7667"
    sha256 cellar: :any,                 arm64_sonoma:  "82616501a4eccafd7b20608afb98870e7f8e19eadd168adfc9853050cf9afda7"
    sha256 cellar: :any,                 sonoma:        "e13afc01e9224d48f0f8a7782a90a75b06c468032020a7c18af3247e6fb48495"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f10a6194456b2b4dbd140b6953b656e7eadc49c8d37cc3a031bb56106809bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be1edebb84a8f3a3fc6d609e49ae2f4c0125b3837ed9243376cd96b879478483"
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

      const TSLanguage *tree_sitter_ruby(void);

      int main() {
        TSParser *parser = ts_parser_new();
        ts_parser_set_language(parser, tree_sitter_ruby());

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
                   "-ltree-sitter", "-ltree-sitter-ruby",
                   "-o", "test"
    expected = "(program (integer))"
    assert_equal expected, shell_output(testpath/"test").strip
  end
end
