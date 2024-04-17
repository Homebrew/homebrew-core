class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.22.5.tar.gz"
  sha256 "6bc22ca7e0f81d77773462d922cf40b44bfd090d92abac75cb37dbae516c2417"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "91174e906f34ae515436be1e48de2e5b703bafc2841c5e5e6d82cc1867430128"
    sha256 cellar: :any,                 arm64_ventura:  "02af6edebaba51aa2edce304f13d72e7b87283d6359fd7cd7e28e0ddd9d56923"
    sha256 cellar: :any,                 arm64_monterey: "54e7641054e8fed9e07c5b97e5ad28668bb576db69345a34118d79686c8926b3"
    sha256 cellar: :any,                 sonoma:         "042cc37dde641a24177d86117d00463416b00f4e4d087cb1bd6b4bc61f8bdab1"
    sha256 cellar: :any,                 ventura:        "a1dcae69ad7864a1b3f66b60ba1f6946169ef8d8cf0699ba2e218c2ef25f345a"
    sha256 cellar: :any,                 monterey:       "7392ae04ded41ced1586dcd29d91e548bb6138ca408f6bbfeb275d474ea98d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a365f9655e139194c3016165abc3798d003fcf784f714e7e34a6eba6ca270651"
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
    system "#{bin}/tree-sitter", "test"

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
