require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-7.1.1.tgz"
  sha256 "cf8a969c2f4ab392c3ac971299861447d39ff4f917fdadfb46ecd95f4ebc20ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaf21aeea6e8d57bed8d4a1b7541e4e54662b1386b30eaf3c281a511f59570f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eaf21aeea6e8d57bed8d4a1b7541e4e54662b1386b30eaf3c281a511f59570f4"
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
