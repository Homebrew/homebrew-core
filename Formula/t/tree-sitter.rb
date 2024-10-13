class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "0a8d0cf8e09caba22ed0d8439f7fa1e3d8453800038e43ccad1f34ef29537da1"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a00912caca6753ad531eee46172ed9335587bacabf405cc8deb8091f1918941"
    sha256 cellar: :any,                 arm64_sonoma:  "5bea44eda513618e12b7bf69ca1689a4d754a4f973c261ca0d4ffbc95c0f3050"
    sha256 cellar: :any,                 arm64_ventura: "eab336b8be8cebf8aa0b47fac7c7524d3409148294ede2a372595e797e5049e5"
    sha256 cellar: :any,                 sonoma:        "cb196846cb0c0bf1a2168112a5e171d7c61a872805348accdf38d878d2a51fa7"
    sha256 cellar: :any,                 ventura:       "f95045d2e440439f0f2c2b7f467b20172e053be1048ec5439cbc7c7ca3bf0c0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3bb5e922d600521bf862ad5a83bff9215888e513f626f40bf87b0136b1407d8"
  end

  depends_on "rust" => :build
  depends_on "node" => :test

  def install
    system "make", "install", "AMALGAMATED=1", "PREFIX=#{prefix}"
    system "cargo", "install", *std_cargo_args(path: "cli")
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
    system bin/"tree-sitter", "generate", "--abi=latest"

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
    system bin/"tree-sitter", "test"

    (testpath/"test_program.c").write <<~EOS
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
    EOS
    system ENV.cc, "test_program.c", "-L#{lib}", "-ltree-sitter", "-o", "test_program"
    assert_equal "tree creation failed", shell_output("./test_program")
  end
end
