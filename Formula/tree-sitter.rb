require "language/node"

class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/v0.20.7.tar.gz"
  sha256 "b355e968ec2d0241bbd96748e00a9038f83968f85d822ecb9940cbe4c42e182e"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "c1fb86aa4f3e621a51b8a3162ffab2acc64ca814f3cd758bf5e167128a90c8dd"
    sha256 cellar: :any,                 arm64_monterey: "6f6f70838e3691e8cd34ded3c2c4e88b39ba1153110bcb9ceb123c5c3d653459"
    sha256 cellar: :any,                 arm64_big_sur:  "ba68148d99a41b39d6fdd5c6461064daf0903d06911ed2970f4a04dc49691ab2"
    sha256 cellar: :any,                 ventura:        "1bc496e96541203fe00d602d69d41ec9f71e4efc81c4d37e0738a25f29407127"
    sha256 cellar: :any,                 monterey:       "e251026a9bbe2ea09165376223c4c82766ce98f7f8393b479d03a7474c61034b"
    sha256 cellar: :any,                 big_sur:        "5beb68d159b38a6712f0fc5acf7b26dc7bf655ce00f8934bf8e5ac043a80932f"
    sha256 cellar: :any,                 catalina:       "5e8d09ddfe2b847f6d4a838d38aed711a282ea358a5ed2a09ec92ab5e14e7925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ee8f6010f5e2e2c94c03ab8375a33f6df5fdea676cdce67f08d8876769e4102"
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
