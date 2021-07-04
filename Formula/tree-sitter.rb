require "language/node"

class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/v0.20.0.tar.gz"
  sha256 "4a8070b9de17c3b8096181fe8530320ab3e8cca685d8bee6a3e8d164b5fb47da"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "cde3ebc240632b22ebb43e06e5a01016f1e90e77e740ef3df0ce0bfcc9d5d3ca"
    sha256 cellar: :any, big_sur:       "5b790b15e898a45d27aadd9e513f46aef3c0de96dce110eced8ffc4bef37af37"
    sha256 cellar: :any, catalina:      "11d66cc7ce50df263c5acae45b334520c7a3314422da3c7050ff9c511f860196"
    sha256 cellar: :any, mojave:        "1bf537d6e22c72586f41cc75cb0f9a496243c5daab3f406f4849e69851ba09fd"
  end

  depends_on "node" => [:build, :test]
  depends_on "rust" => :build

  on_macos { depends_on "emscripten" => [:build, :test] }

  def install
    system "make", "AMALGAMATED=1"
    system "make", "install", "PREFIX=#{prefix}"

    on_macos do
      # NOTE: This step needs to be done *before* `cargo install`
      cd "lib/binding_web" do
        system "npm", "install", *Language::Node.local_npm_install_args
      end
      system "script/build-wasm"
    end

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end

    on_macos do
      # Install the wasm module into the prefix.
      # NOTE: This step needs to be done *after* `cargo install`.
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

    on_macos do
      # test `tree-sitter build-wasm`
      ENV.delete "CPATH"
      system bin/"tree-sitter", "build-wasm"
    end
  end
end
