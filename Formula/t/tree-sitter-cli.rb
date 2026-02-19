class TreeSitterCli < Formula
  desc "Parser generator tool"
  homepage "https://tree-sitter.github.io"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.5.tar.gz"
  sha256 "8e012493b2103e0471d3aba8048b73bc1a3138132974e2fd8bfb89a63e62f478"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    formula "tree-sitter"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf2ae5557c043a1f777ec6840364f296d9a3a15b479913cd948d5acf7086147e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb10adfaf8d9e9cbaceb8677c20e91470cbc4f3d9099d43b93bd658c6c826e89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b80f8685f6d2985311938b27167d011ad8bc1fc144b40d3ba9f52f4e35dc82df"
    sha256 cellar: :any_skip_relocation, sonoma:        "c98b70361b5b9113590e4557d92844536ebbdca0d85c1d98c4d776a66bfe5022"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc0ec59d1646f2dcb74567fea959829a52b5d0733539178b74dcec0cf765df4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62349563eb8f3e8b31e41511167c7321cb3e583b03f6e50fe1b32cd9be44be7e"
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
