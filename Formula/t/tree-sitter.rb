class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "b21065e78da33e529893c954e712ad15d9ad44a594b74567321d4a3a007d6090"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6147c30ee016961218015eef4fbd66ff983bb43150e2be7c40701096bac11570"
    sha256 cellar: :any,                 arm64_ventura:  "5556860893168102f2001e4f266f1229063e34d70afd1f6b9341838c74040cc2"
    sha256 cellar: :any,                 arm64_monterey: "5069bc525fb2a33375ca4d116044685542e569d8f071af6ad072255567ea0845"
    sha256 cellar: :any,                 sonoma:         "4f296702f41747857b15dc72437e31f434ed8814a32a5b6068f56e9d63224623"
    sha256 cellar: :any,                 ventura:        "c5ae186e243661a35d1a07ba45f2f5cc2524d28e4a53014ef04eab6027f9cc58"
    sha256 cellar: :any,                 monterey:       "7b64275c9cc1e7fc7c20fcd31acc2db3975a3ec923ef1f36f93c8df4b9d7eb54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f55a226b7da26aa94607478b424c0f7f88df019841778cd2b4ed70fb691a1df"
  end

  depends_on "rust" => :build
  depends_on "node" => :test

  # Fix Makefile for BSD `install`
  # https://github.com/tree-sitter/tree-sitter/issues/3157
  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/76faa188751724c04931ebb3dfb4d18152424cfc/devel/tree-sitter/files/patch-makefile-install.diff"
    sha256 "fdce92d9ebcad0c25f0b7cd4e0eae810e2670ece47631740b002f2a3ea99f7cf"
  end

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
