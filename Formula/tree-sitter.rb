class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/0.16.5.tar.gz"
  sha256 "3c6357d1a153c43f481d07f1a8743ed8b3134a2934689d564795a0d083ff7c7e"
  head "https://github.com/tree-sitter/tree-sitter.git"

  def install
    # this shell script invokes clang or CC, and builds a .a with ar
    system "script/build-lib"

    lib.install "libtree-sitter.a"
    include.install "lib/include/tree_sitter"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <string.h>
      #include <tree_sitter/api.h>

      int main(int argc, char* argv[]) {
        TSParser *parser = ts_parser_new();
        if (parser == NULL) {
          return 1;
        }

        // Because we have no language libraries installed, we cannot
        // actually parse a string succesfully. But, we can verify
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
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltree-sitter", "-o", "test"
    assert_equal "tree creation failed", shell_output("./test")
  end
end
