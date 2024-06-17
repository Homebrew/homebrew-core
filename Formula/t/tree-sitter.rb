class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.22.6.tar.gz"
  sha256 "e2b687f74358ab6404730b7fb1a1ced7ddb3780202d37595ecd7b20a8f41861f"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "acb1a8659cd284d8a72e1fa75e43fc319b649e5a9b935519dafe1d88a4fbfb0a"
    sha256 cellar: :any,                 arm64_ventura:  "1f1136ed859849e34a77202ec68651b9b5500dd36c71f97fde4e1f417da0684f"
    sha256 cellar: :any,                 arm64_monterey: "fb43e5d840613e4780d2ec0703a887a12b5595e97d3783bf1b7cd8bb006e1d39"
    sha256 cellar: :any,                 sonoma:         "ff7a983bcb1e831ff7ef0a1e1b7be2f94bed539ba1353913a45d72b9efef75dc"
    sha256 cellar: :any,                 ventura:        "fa5f06dd43c5f8ccd4ced678db9177fc32bda8f21c605cb021b95adc6033cc34"
    sha256 cellar: :any,                 monterey:       "591fb80b98afd85dacba85564a10dca6407121dca170b6a761ecee9b3672d6b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5c20737bc92564aba096a2695446ea3017d1ae79f993715653aba5f098793ea"
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
