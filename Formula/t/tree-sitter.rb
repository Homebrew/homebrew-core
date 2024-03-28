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
    sha256 cellar: :any,                 arm64_sonoma:   "864d65c35270a1150028cb1767d71f4549a4b64b9f4abd029f97641484c12971"
    sha256 cellar: :any,                 arm64_ventura:  "632264bbf86e5838f1175aa75c3fe4540a617ff66aad617af46e78ad3c6d1303"
    sha256 cellar: :any,                 arm64_monterey: "2f496671caec440c0a11858dc79caa81e32a4743acee7871def02fd32305ecf9"
    sha256 cellar: :any,                 sonoma:         "a5005dda76bca989d76c0c14dee5faa4e0ccfbff6685f0a24c1b3a477a973348"
    sha256 cellar: :any,                 ventura:        "f34ec18b64a8d010078b4cf52289481709e365333df027a30de2caedcd6e4512"
    sha256 cellar: :any,                 monterey:       "68c5c14bc68ca86f1e2768d0f07171eb5238282e87a130f0021b32cf904b6c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ca7b72329bbbf4fd0f1a1539a4ed1adbbd243a22599b998c1a26e7fcb189f3c"
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
