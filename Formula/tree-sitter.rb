require "language/node"

class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/v0.20.2.tar.gz"
  sha256 "2a0445f8172bbf83db005aedb4e893d394e2b7b33251badd3c94c2c5cc37c403"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "97339409b6fc51f5db33633fa563f60de778b5bce732ab2079e43cd2fcbc2132"
    sha256 cellar: :any,                 arm64_big_sur:  "a2de5338a614bea1152bab80d9545fc43681a422c84bb69520a8bbefc35b8d1d"
    sha256 cellar: :any,                 monterey:       "ec802e84633532f8524b56c68956d6e5fb8bca8e06eb8340e2d8b04a6174d12b"
    sha256 cellar: :any,                 big_sur:        "d4c89927faf3a4cc8bdff8a610728286f364a874db4779a87b9a6954dac246a4"
    sha256 cellar: :any,                 catalina:       "1b0b0a0b17deee94650445012f00e38cc53bb8bab01c95343f5efded43343c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef83da037ec0ae5d47d57d50d3bed4903b4691184caa04e8a378cd1b808d4617"
  end

  depends_on "emscripten" => [:build, :test]
  depends_on "node" => [:build, :test]
  depends_on "rust" => :build

  def install
    system "make", "AMALGAMATED=1"
    system "make", "install", "PREFIX=#{prefix}"

    # NOTE: This step needs to be done *before* `cargo install`
    cd "lib/binding_web" do
      system "npm", "install", *Language::Node.local_npm_install_args
    end
    system "script/build-wasm"

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end

    # Install the wasm module into the prefix.
    # NOTE: This step needs to be done *after* `cargo install`.
    %w[tree-sitter.js tree-sitter-web.d.ts tree-sitter.wasm package.json].each do |file|
      (lib/"binding_web").install "lib/binding_web/#{file}"
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

    # test `tree-sitter build-wasm`
    ENV.delete "CPATH"
    system bin/"tree-sitter", "build-wasm"
  end
end
