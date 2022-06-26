require "language/node"

class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/v0.20.6.tar.gz"
  sha256 "4d37eaef8a402a385998ff9aca3e1043b4a3bba899bceeff27a7178e1165b9de"
  license "MIT"
  revision 1
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "05e634e8682ee3cf14c22518255b2d73be8d0a3370d806d5bf4ba1141ce6439a"
    sha256 cellar: :any,                 arm64_big_sur:  "674d1925f358902b0d8eec68114e11e754227e927cf0b1845cc2c697dffb314b"
    sha256 cellar: :any,                 monterey:       "80387d9d1eccb9be160e3f8b535476e1626312930cdb706d8f214773caaa7783"
    sha256 cellar: :any,                 big_sur:        "b1e7629302fc421a676ada74e8b556d136482c2f5459f16429815acd8e8011e3"
    sha256 cellar: :any,                 catalina:       "1a969186a6841f3d92cd55858dbe652b6a588ccb7a2207a4e6df84d12cd6c930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a026eeeb802cb31b2de45b6c7bf63112ac16cc84ce7263cf9aafa7b3db6dc969"
  end

  depends_on "emscripten" => [:build, :test]
  depends_on "node" => [:build, :test]
  depends_on "rust" => :build

  # fix build with emscripten 3.1.11
  # remove in next release
  patch do
    url "https://github.com/chenrui333/tree-sitter/commit/9e9462538f2fa30fb8c7a3386c1cb2a8ded3d0eb.patch?full_index=1"
    sha256 "ce6e2305da20848aa20399c36a170f03ec0a0a7624f695b158403babbe15ee30"
  end

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
