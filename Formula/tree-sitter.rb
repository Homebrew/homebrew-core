require "language/node"

class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/v0.18.1.tar.gz"
  sha256 "1d679ae60434938ca8fb874776da579064a25adf26deec91ed8587dded17bc7d"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "09ccaf41f94622f3e76cc955b020dde931701655df0f69984127fb241db54c6c"
    sha256 cellar: :any, big_sur:       "56771272b9191a093cf87383289115cedf0377556292367e647b6da536ac2e63"
    sha256 cellar: :any, catalina:      "7dedbbe44434bcff54d9a4a1733833ab8a1a5cdf2f9e2de36f3ab941b7d5c590"
    sha256 cellar: :any, mojave:        "67b1d17c842134054119843e0c931bc99d68ba7af94235755c6df7c64adff400"
  end

  # emscripten does not currently work on ARM,
  # so we skip building the wasm module there.
  depends_on "emscripten" => [:build, :test] unless Hardware::CPU.arm?
  depends_on "node" => [:build, :test]
  depends_on "rust" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    # Build wasm module only on Intel
    # NOTE: This step needs to be done *before* `cargo install`
    unless Hardware::CPU.arm?
      cd "lib/binding_web" do
        system "npm", "install", *Language::Node.local_npm_install_args
      end
      system "script/build-wasm"
    end

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end

    # Install the wasm module into the prefix.
    # NOTE: This step needs to be done *after* `cargo install`.
    unless Hardware::CPU.arm?
      %w[tree-sitter.js tree-sitter-web.d.ts tree-sitter.wasm package.json].each do |file|
        (lib/"binding_web").install "lib/binding_web/#{file}"
      end
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
    system bin/"tree-sitter", "generate"

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

    # test `tree-sitter web-ui`
    ENV.delete "CPATH"
    system bin/"tree-sitter", "build-wasm" unless Hardware::CPU.arm?
  end
end
