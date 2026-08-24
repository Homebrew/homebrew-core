class TreeSitterCli < Formula
  desc "Parser generator tool"
  homepage "https://tree-sitter.github.io"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.13.tar.gz"
  sha256 "ece24c3c5e2a76384075e830c7139b59fce8fb01e4ef8436fab08bbe10444c89"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    formula "tree-sitter"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6f02581ed0e112cabdd0466395ea3b19354cb4bbb6dad2fea28e4fc94a88c03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4a8e899399de5bbc95c71851969015b2df1a2bad23265969da586e4c9fa1ba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bf06650787886380bedd0143da65836e667f89d6ac171a9830c61e140564a1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "629009cbda7253105717392c0a7bc42f098ef91f2687bbae057049a82c0c6964"
    sha256 cellar: :any,                 arm64_linux:   "0d677873befaff3c4316771d286e00ff4bef40bf3312469ca9cc11dae7989041"
    sha256 cellar: :any,                 x86_64_linux:  "3a33ea17a61de179699cff8c751e54504232a5b928962d3a083b199a10b44b5d"
  end

  depends_on "rust" => :build
  depends_on "node" => :test

  uses_from_macos "llvm" => :build

  link_overwrite "bin/tree-sitter"
  link_overwrite "etc/bash_completion.d/tree-sitter"
  link_overwrite "share/fish/vendor_completions.d/tree-sitter.fish", "share/zsh/site-functions/_tree-sitter"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"tree-sitter", "complete", shell_parameter_format: :arg)
  end

  test do
    # a trivial tree-sitter test
    assert_equal "tree-sitter #{version}", shell_output("#{bin}/tree-sitter --version").strip

    # test `tree-sitter generate`
    (testpath/"grammar.js").write <<~JS
      module.exports = grammar({
        name: 'YOUR_LANGUAGE_NAME',
        rules: {
          source_file: $ => 'hello'
        }
      });
    JS
    system bin/"tree-sitter", "generate", "--abi=latest"

    # test `tree-sitter parse`
    (testpath/"test/corpus/hello.txt").write <<~EOS
      hello
    EOS
    parse_result = shell_output("#{bin}/tree-sitter parse #{testpath}/test/corpus/hello.txt").strip
    assert_equal("(source_file [0, 0] - [1, 0])", parse_result)

    # test `tree-sitter test`
    (testpath/"test/corpus/test_case.txt").write <<~EOS
      =========
        hello
      =========
      hello
      ---
      (source_file)
    EOS
    system bin/"tree-sitter", "test"
  end
end
