class TreeSitterCli < Formula
  desc "Parser generator tool"
  homepage "https://tree-sitter.github.io"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "7f4a7cf0a2cd217444063fe2a4d800bc9d21ed609badc2ac20c0841d67166550"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    formula "tree-sitter"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67c531bf639d9778127882efaaec86e64f0058ba0795d8e264fd3045c3c462be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fea2b3b319d05696e077052102b934930ad649f38f65ae7fbad84616bff8b220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d49b5eee85ac678ff96c24ff1fd5c7a443516cb7bd30865548ecf737675e615"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeffcd2c8d7eab67cf0bd434b7efc3aa2e998ac07acf1d0653911e3de8e1691e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1654a0563e39c96920b2caee30e610b8f33506640ed996c531bd46de006957b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e1b2d276c2f067aab2fce345e9787ec1aa1dde38f12141b9272630b9558a448"
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
