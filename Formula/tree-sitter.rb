require "language/node"

class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/v0.20.7.tar.gz"
  sha256 "b355e968ec2d0241bbd96748e00a9038f83968f85d822ecb9940cbe4c42e182e"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ed7732dfb93b41a1a9dec118f119903214b2733059a4666b4811a8c0b4995fb6"
    sha256 cellar: :any,                 arm64_big_sur:  "1ca16211e94d5a9c72785bf1206141c18c10836027a8e7e58961809fb1e10141"
    sha256 cellar: :any,                 monterey:       "c863b441b7df332c195dd7be16c67108d2bffab77cb6b5d336c59b77d2ac28b0"
    sha256 cellar: :any,                 big_sur:        "49fc36d28fb16ab79081fd579585be955473a4c196971385b8425cb928fd8959"
    sha256 cellar: :any,                 catalina:       "84744c0f0ac2af90eb3929ffedcd3284906da54186d923f3449e98cf53aea8d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a9847f8198c9fc9b3da2b65a37e397a1eabaf549f0f7cb93a18a47a6fa0254c"
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
