class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "0c829523b876d4a37e1bd46a655c133a93669c0fe98fcd84972b168849c27afc"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "8372628b9a7ed4290b61ec9bf32deb696d1cdcc0e359b10104f60e4c1ce043b8"
    sha256 cellar: :any,                 arm64_ventura:  "6c1b5522caf843e5380a57897c8a0e6ecee0803ac0615b4fc266fdc299018cd6"
    sha256 cellar: :any,                 arm64_monterey: "723197da6498c8f90d53001f0672808a202b29219301866662130cc1c22321fa"
    sha256 cellar: :any,                 sonoma:         "6f92b83165eeaa97c52ddfae7d1319759a0ca43b4b7c0229d56ce6646e8e576b"
    sha256 cellar: :any,                 ventura:        "c7db892c6da0e13db9a3b1678fb300b3fc59e226862365519e216d11e6da866d"
    sha256 cellar: :any,                 monterey:       "6de75cd81aaf3f32aa6eeacbb6a495e408b65aa61e44010f93695b6eda392547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1661898fd95f0faf8aa8b65fee585a85cc85425daf32e48778faed7b2b0a04d"
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
