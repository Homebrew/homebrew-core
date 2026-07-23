class TreeSitterCli < Formula
  desc "Parser generator tool"
  homepage "https://tree-sitter.github.io"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.11.tar.gz"
  sha256 "1bab01ed21464f3272665b9c60e39ee79f68da1333e80b23f2c9356569d06971"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    formula "tree-sitter"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3c4134bab001d13a6a0e065a161dbe3612179f4895ce407b505c8ad41260cd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81281f2a8ded7a5cd6a404c5878c9dcf4c41aa8b97c454c3e6eaefffead35c31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62083efcfe2f3bf70dbd22f6d1ffc32640874c1bea8249445af959be8f7f0f71"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b601a938d784fe60ec62b765a73415971bf57d7b8a8f56d69cbb368c6d9dd95"
    sha256 cellar: :any,                 arm64_linux:   "42d65a595d16473fab57850314da97219ecd40c3ed9e6d880488c00077deba0d"
    sha256 cellar: :any,                 x86_64_linux:  "2d37480c0f1ceaac0a78b78d5b5956ae15e4b88de34a98768687e72f32595ce2"
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
