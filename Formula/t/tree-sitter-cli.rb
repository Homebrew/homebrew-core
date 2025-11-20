class TreeSitterCli < Formula
  desc "Parser generator tool"
  homepage "https://tree-sitter.github.io"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.25.10.tar.gz"
  sha256 "ad5040537537012b16ef6e1210a572b927c7cdc2b99d1ee88d44a7dcdc3ff44c"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    formula "tree-sitter"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d7997c710a29c99f823c4f19596db1ec1511c204b7b74c45d7c9eff5ec637f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9f79036f5265e03b7365ce303c413b51ce1f66c3c20362f4d040fb2b6f8327d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9311741beeb74356d9d7653a64beb2990858389457849d0d96d2cd2580580f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd67480759e3b56974e91cc6c47af09113f7dfb5de2e92ff4871dd12b1eec0e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f55705990d6330ff1958e780708a86fed5e0bd9bbadcd93598271bcf98e5315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0b636167c67993dc97c347b7b5a01b04af40a3bcdb2803fcd8980efb58de312"
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
