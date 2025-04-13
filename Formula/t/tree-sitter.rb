class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.25.3.tar.gz"
  sha256 "862fac52653bc7bc9d2cd0630483e6bdf3d02bcd23da956ca32663c4798a93e3"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3af9b0daa0a0abc67857dfe737b1b3efea32dd2f8839e650d4ab5c7edbfa7498"
    sha256 cellar: :any,                 arm64_sonoma:  "583a1198bf012237f4d55214f4e229c73e36c2646b039f753b23e88067de2a87"
    sha256 cellar: :any,                 arm64_ventura: "45f1d76ef7d78f9159f9b362dfc91d22575c5e5a3d4b34cabf5db8c83bfde169"
    sha256 cellar: :any,                 sonoma:        "077aeb52873a985c5f869cbcfbc62a7c8e135256038b797cd1ca111266b9e386"
    sha256 cellar: :any,                 ventura:       "2b0e5434ddbaa8b5236aa132a10aa7ad93a78ec40ab14926c2ece1b7f91bf250"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f79aed3eaf3dc58b2fee7231bf5e7ad9e17b4acd5729e65b6df401bc9259f59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79afaf8e3fcbe5cd4bf4e1f72fea4cb77ac6da024da49cbd392db157732c59a3"
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
    (testpath/"grammar.js").write <<~JS
      module.exports = grammar({
        name: 'YOUR_LANGUAGE_NAME',
        rules: {
          source_file: $ => 'hello'
        }
      });
    JS
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
