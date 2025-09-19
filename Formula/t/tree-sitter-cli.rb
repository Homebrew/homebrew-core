class TreeSitterCli < Formula
  desc "Parser generator tool"
  homepage "https://tree-sitter.github.io"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "ed464a90b7d73cdcf7acecf132186b905998f80f216be262f101ffc49d6459d7"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    formula "tree-sitter"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65ceb829a9d99ea4a004687b1b83853cc083a0e001b6b997dd6b2956ec42ce81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7d053031863155628721d3f44a89d735202ae9db48edf0cba6c527d89a0ebd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "700f053f1e5936acf17504e339b054a008c08e6a15db94bb4c60aefa07d08e18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1b3cffb1d9ef7bcd6c9a18fd06717f08032ead6b2ed398f7e0bccb51cba3aab"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4d73118c31a240474de4f3284486176b984987533e7278ead12138b1781195f"
    sha256 cellar: :any_skip_relocation, ventura:       "31ae8aa35558201ef8d3d55a0f4bcf2d23ee5ed5cf3877b52610ae4249ecbff3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c66453f3b67710840cf232113ec34ce53eba60c95712d24bee1a8f8ea40d80a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "835e1d336e3d68c714a1bcff83dd9f1bb765264788f92faf7603e1a4a48e7fcf"
  end

  depends_on "rust" => :build
  depends_on "node" => :test

  link_overwrite "bin/tree-sitter"
  link_overwrite "etc/bash_completion.d/tree-sitter"
  link_overwrite "share/fish/vendor_completions.d/tree-sitter.fish", "share/zsh/site-functions/_tree-sitter"

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
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
    (testpath/"test"/"corpus"/"test_case.txt").write <<~EOS
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
