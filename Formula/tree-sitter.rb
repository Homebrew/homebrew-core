require "language/node"

class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/0.18.0.tar.gz"
  sha256 "574458dbc8b6761027d3090bc2fd474f17ea77d875d4713ed9260d0def125bce"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "99f761f4f254e03c4a1340389f0997e168695764f448984b691b4c2ed636a228" => :big_sur
    sha256 "bcb908e01eb052b68fb3780f12d9cf74da9b36967f9cd6be1f37ffcce5a65805" => :arm64_big_sur
    sha256 "6acc385bf4be8cbbc3199a57c918346fc724f4da7afbdd3bc7612595b04d27c2" => :catalina
    sha256 "d15a8f3640166e717d4dd1f805b19aa48272c72d414bde3838d66a6a6d8c2197" => :mojave
  end

  depends_on "emscripten" => [:build, :test]
  depends_on "node" => [:build, :test]
  depends_on "rust" => :build

  def install
    cd "lib/binding_web" do
      system "npm", "install", *Language::Node.local_npm_install_args
    end
    system "script/build-wasm"

    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end

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

    # test `tree-sitter web-ui`
    ENV.delete "CPATH"
    system bin/"tree-sitter", "build-wasm"
    fork do
      exec bin/"tree-sitter", "web-ui"
    end
    sleep 10
    system "killall", "tree-sitter"
  end
end
