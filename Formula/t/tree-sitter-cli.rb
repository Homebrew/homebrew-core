class TreeSitterCli < Formula
  desc "Parser generator tool"
  homepage "https://tree-sitter.github.io"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.8.tar.gz"
  sha256 "e6826b7533ec3a885aba598377a6d20b5a6321ff3db76968e960c2352d3a5077"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    formula "tree-sitter"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27985d26c088b6e8dea83fab37d26a442b3a2331b7866fa6caf4748341f9ab36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "821b40e8b13f00c3a6a3abe96d30c7069506db326b475f997bc105ab6958a2a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25a13f40370a36b85d3adddc547ae888e468ce282b91f56438e2af72d17885d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5426080ff092917848f1776f22a30756263a5eb59bdd7e9760c5d034941f435b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe066738a518885301f8e096d6434a9849c610b73a4843c3da3f136d0b462d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41772391e68de43abe73e4a43dabf74320e7145ab0d60ffa9862f8aa74f767be"
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
