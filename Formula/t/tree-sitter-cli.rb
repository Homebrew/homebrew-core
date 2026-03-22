class TreeSitterCli < Formula
  desc "Parser generator tool"
  homepage "https://tree-sitter.github.io"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.7.tar.gz"
  sha256 "4343107ad1097a35e106092b79e5dd87027142c6fba5e4486b1d1d44d5499f84"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    formula "tree-sitter"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "624bb6d7a207dabe007ed2a969472996ca13b3abeecb1f0c4ac0c26df4069b0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cc3e06528c6677461d28a3c9b6066592cca698762c292d8eb87775e84649ba2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2d732527598e565e482628c0ca51000325c9bc510259edfd9cfd5470063ec1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b370e144960aff313056418f983ed8d1323e4792dab1a3d164417f1593adcaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f0e4b1842b051f7ce18ca9deb23d657c45042d28d187c7eeba6dd4d69e7f1e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d0a74ad1d5ec86a25b068228b9f1e22777e3bf8e2bc1adea0f27cbee14321b3"
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
