require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-7.2.0.tgz"
  sha256 "b1e2131af70cafb93dd0fb50abd6580b17bd322ce29b2a42327f4322c58db38e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dcd400a8748fb0d9ef894e5aa67ee334a76edd439d9392d52bea74c94a7ae3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaf21aeea6e8d57bed8d4a1b7541e4e54662b1386b30eaf3c281a511f59570f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eaf21aeea6e8d57bed8d4a1b7541e4e54662b1386b30eaf3c281a511f59570f4"
    sha256 cellar: :any_skip_relocation, ventura:        "0280f0d315e106e36b0ba4393bc01ab7d992339d44d1ff6bce2b3dcdb94c1585"
    sha256 cellar: :any_skip_relocation, monterey:       "af0e008fbb823b5520a58b889260f12f53579e70c9c8bf48f3ad275598e71c81"
    sha256 cellar: :any_skip_relocation, big_sur:        "af0e008fbb823b5520a58b889260f12f53579e70c9c8bf48f3ad275598e71c81"
    sha256 cellar: :any_skip_relocation, catalina:       "af0e008fbb823b5520a58b889260f12f53579e70c9c8bf48f3ad275598e71c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaf21aeea6e8d57bed8d4a1b7541e4e54662b1386b30eaf3c281a511f59570f4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.mjs").write <<~EOS
      #!/usr/bin/env zx

      let name = YAML.parse('foo: bar').foo
      console.log(`name is ${name}`)
      await $`touch ${name}`
    EOS

    output = shell_output("#{bin}/zx #{testpath}/test.mjs")
    assert_match "name is bar", output
    assert_predicate testpath/"bar", :exist?

    assert_match version.to_s, shell_output("#{bin}/zx --version")
  end
end
