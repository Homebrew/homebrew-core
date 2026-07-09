class TreeSitterCli < Formula
  desc "Parser generator tool"
  homepage "https://tree-sitter.github.io"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.10.tar.gz"
  sha256 "450cb85fd1af34111eb162e931e0e9e4d4dbf23fc09b9cb56f6299a1a80483b6"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    formula "tree-sitter"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ba021769d76bc448670294982e9c23e57a566f20edf15a591643008d74ab25c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93067baab6c01f37037d44b24edce67401d29936bd46da7c0cb22337ec2d3d42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8647608a9b5eeb6e0adab147fb14f6c6d5d3cfa5110ac1004244659751ac9485"
    sha256 cellar: :any_skip_relocation, sonoma:        "91726935c45d13688d1b43e6261fb44f591679df40f5ac081f3fc81ec1a3a3bc"
    sha256 cellar: :any,                 arm64_linux:   "0b5553db5ac9fa28e236d81d2c63b8674f6308764e2c3beab50c0ed289e87907"
    sha256 cellar: :any,                 x86_64_linux:  "eca9719b340de2bb9f8fc47527f99f14302d2b8ace640d5e3b73dbe7ab6d654b"
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
