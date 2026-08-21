class TreeSitterCli < Formula
  desc "Parser generator tool"
  homepage "https://tree-sitter.github.io"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.12.tar.gz"
  sha256 "428e2b182fe38eddc100d8bd851e47c96921a69281b66abafc25ba4b0aaeeeab"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    formula "tree-sitter"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65e98a2e698174ba4e724445cc0479fc2ff43efb99e1d1a4d869f0e27174dd4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbedb62b597e02ea3bcf66d0b37b60edd4b5e3fbf51c267bcd13d27b0d6a2248"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "811523b3aa1c79f593eb577f4e38b991d64c22eb2594b4f15457a529ba69aabd"
    sha256 cellar: :any_skip_relocation, sonoma:        "693e1c0ccbc8f81161dbb0fe4c8b579307a8439c97f246e65acde5d60bdd72e3"
    sha256 cellar: :any,                 arm64_linux:   "7191dfb20b4b3c5b0bdb8f1f1e5b019c598394119bda7bd5da5cdc1a9f52717f"
    sha256 cellar: :any,                 x86_64_linux:  "63b65ebd0b0c3a40d65bc41e3714c7b0c91405979c5e5e56921254e6ab21754e"
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
