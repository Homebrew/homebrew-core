class TreeSitterCli < Formula
  desc "Parser generator tool"
  homepage "https://tree-sitter.github.io"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.9.tar.gz"
  sha256 "8e14780500933f43d86662fcaa1b0ce99ebe9c220f4680bc929dce09a0e0cfc6"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    formula "tree-sitter"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2fd4dbcd920e4f89ebb5571e0fdef01968504be04f2cddbeea52dedf886527c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0777c63f4741915c9acab1def9a39abc50573571baa5f342332ef09ef5e9e43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f141ae2b77499ffb083432a1f176405b499450d80ac0051839a529a7984d92f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ca73fbff9639286b5d55548be354b107998629c40068332237c76c9d064782e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93eafc53d90ceab37359197d5dc2780e8cccd2109ea38fb80e80e83ed589c97b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14565e2d575cfbc5a7cbc45ae0f4f1160627497ef929f886b74d8d73e1e76fe1"
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
