class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.25.5.tar.gz"
  sha256 "17a72b9dd7525b01d8fabf9ebee0edd3203fe3058ccc73cbc5e2070ccbe26c0d"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "900215245162c2d3f87cde10a9b65eab2af55e3d59ee331fc21cb4a92ee6ee6b"
    sha256 cellar: :any,                 arm64_sonoma:  "5bed6f377f7e0ea14733c146ddc10c7021ffc4b1f8a4923c970dbf34fdde5194"
    sha256 cellar: :any,                 arm64_ventura: "15cc58800641d02c0b68af335bd138fe2de3fc21e089daeb20a054f1b11dff08"
    sha256 cellar: :any,                 sonoma:        "cae87014a9558f3d7d1de9c9c45c0b89b6802b9b6b423123381b43ea0b963fb1"
    sha256 cellar: :any,                 ventura:       "66916e949bd6c91f451e44b3d999ff403dd3abd067aef324582de89c6536fa39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cd46903fa0db0fab42b963d0baefb6525fee7eec77597be32fea15cb3eb0e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "297e99fafbba42afb8246b6fd5d9179fd6057ee3cca515c0cc954a092318325f"
  end

  depends_on "rust" => :build
  depends_on "node" => :test

  def install
    system "make", "install", "AMALGAMATED=1", "PREFIX=#{prefix}"
    system "cargo", "install", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin/"tree-sitter", "complete", shell_parameter_format: :arg)
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
