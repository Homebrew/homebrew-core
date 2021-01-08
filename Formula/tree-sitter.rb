class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/0.18.0.tar.gz"
  sha256 "574458dbc8b6761027d3090bc2fd474f17ea77d875d4713ed9260d0def125bce"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "242c2c1e1867674641caec723aa5d8865f6912f83c2475de2c43fdad25282e36" => :big_sur
    sha256 "97c837df6b17cdaa5653638e48d043750e3917b3681b76000fdfaae31b8f667d" => :catalina
    sha256 "d9302818f0caddc5a60e0c5a6a3f9f316da0c76322fc55d986ad4982e6661e30" => :mojave
  end

  depends_on "rust" => :build
  depends_on "emscripten" => :test
  depends_on "node" => :test

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    # a trivial tree-sitter test
    assert_equal "tree-sitter #{version}", shell_output("#{bin}/tree-sitter --version").strip

    # test `tree-sitter generate`
    (testpath/"grammar.js").write <<~EOS
      module.exports = grammar({
        name: 'YOUR_LANGUAGE_NAME',
        rules: {
          source_file: $ => 'hello'
        }
      });
    EOS
    system "#{bin}/tree-sitter", "generate"

    # test `tree-sitter parse`
    (testpath/"test/corpus/hello.txt").write <<~EOS
      hello
    EOS
    parse_result = shell_output("#{bin}/tree-sitter parse #{testpath}/test/corpus/hello.txt").strip
    assert_equal("(source_file [0, 0] - [1, 0])", parse_result)

    # test `tree-sitter test`
    (testpath/"test"/"corpus"/"test_case.txt").write <<~EOS
      =========
        hello
      =========
      hello
      ---
      (source_file)
    EOS
    system "#{bin}/tree-sitter", "test"

    (testpath/"test_program.c").write <<~EOS
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
    EOS
    system ENV.cc, "test_program.c", "-L#{lib}", "-ltree-sitter", "-o", "test_program"
    assert_equal "tree creation failed", shell_output("./test_program")
  end
end
