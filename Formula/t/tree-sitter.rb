require "language/node"

class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.20.8.tar.gz"
  sha256 "6181ede0b7470bfca37e293e7d5dc1d16469b9485d13f13a605baec4a8b1f791"
  license "MIT"
  revision 1
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9c5ff6c727c1e2276f3cfbe64373bd57d8699425b533796b2413ed4e8bc1e3a1"
    sha256 cellar: :any,                 arm64_ventura:  "80f5d110450dfa623f0ff043bfb9279a03e760aafa8b67a8f919f8371a8a4282"
    sha256 cellar: :any,                 arm64_monterey: "d65d3a05944e834d25950b9fa1d3d79a306af2c28b209aaac043e546c0577965"
    sha256 cellar: :any,                 arm64_big_sur:  "20c1f77800a47d9fd3f055a9b33e06f1782e5b897541b6935262efb831d29c45"
    sha256 cellar: :any,                 sonoma:         "0415c0fdf2750387f23f713c5081dad3c928149bac6be85b4d0826f08075b4e7"
    sha256 cellar: :any,                 ventura:        "0b96dc12579c8693392a737e0939c5956f88d9d7beddb18ee045e127d359096b"
    sha256 cellar: :any,                 monterey:       "84af6fb8f8980273ecc06099ad359dc100a13e0535c2f5ffe5380e7e4a50baed"
    sha256 cellar: :any,                 big_sur:        "b025e1d6e7ed804c5cf099b4a6bea0dbbf09752aef4582916678dd88f2cd0ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d413c47e7b8641aae812d19b39c3f927088e450eabde992f3d7cc32de7d29aa9"
  end

  depends_on "node" => [:build, :test]
  depends_on "rust" => :build

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build
  uses_from_macos "zlib"

  on_macos do
    on_intel do
      depends_on "gdbm"
    end
  end

  # Use the latest tag if possible
  resource "emsdk" do
    url "https://github.com/emscripten-core/emsdk/archive/refs/tags/3.1.51.tar.gz"
    sha256 "6edeb200c28505db64a1a9f14373ecc3ba3151cebf3d8314895e603561bc61c2"
  end

  def install
    # Use the version of `emscripten` found in
    # https://github.com/tree-sitter/tree-sitter/blob/v#{version}/cli/emscripten-version
    resource("emsdk").stage libexec/"emsdk"
    cd libexec/"emsdk" do
      system "./emsdk", "install", "3.1.29"
      system "./emsdk", "activate", "3.1.29"
    end

    ENV.prepend_path "PATH", libexec/"emsdk/upstream/emscripten"
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

    # Remove x86_64 only binary
    node_modules = libexec/"emsdk/upstream/emscripten/node_modules"
    (node_modules/"google-closure-compiler-osx/compiler").unlink if Hardware::CPU.arm?
  end

  test do
    ENV.prepend_path "PATH", libexec/"emsdk/upstream/emscripten"

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
