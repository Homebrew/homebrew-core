class TreeSitterCli < Formula
  desc "Parser generator tool"
  homepage "https://tree-sitter.github.io"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "d35c96e68736bd9569d2757c3cc71052485f33082c3825f1aed9d0e86013a159"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    formula "tree-sitter"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7511d666e46b50ccec5e7c4a92ba84a975c31da1889974707cc9f3b8ea001f9a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1e4865e90a81586656c0027daef6046757968659c5cebe1f99321ab4e04a021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "60e4cb5e6ccd6a68e0c0eaddbc6038445cb10b371d3aec47ba258fb3f37617c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "d0e56ea40a11bd7014eeaa98355b36569c6bd7d24ddfd2198f653fdbe73ec15b"
    sha256 cellar: :any,                 arm64_linux:       "19eb18ac3cf6c11416d2143764efc8c0928ac6e462423ad4578decfbddceacf1"
    sha256 cellar: :any,                 x86_64_linux:      "88c855f4b54e377a69cb86c457b99716015d0f9e0d4d5b75f01482a37ac747cf"
  end

  depends_on "rust" => :build
  depends_on "node" => :test

  uses_from_macos "llvm" => :build

  link_overwrite "bin/tree-sitter"
  link_overwrite "etc/bash_completion.d/tree-sitter"
  link_overwrite "share/fish/vendor_completions.d/tree-sitter.fish", "share/zsh/site-functions/_tree-sitter"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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
