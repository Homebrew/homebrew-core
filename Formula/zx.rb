require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-7.1.0.tgz"
  sha256 "8784c1248ccf4aa02126431c7831e4366c3f49ca370e112d044c6f91b02f8104"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffa423e8b7768af45be92c2aa544334f46b0b7db1abf8086e23ee2e1b9530c08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffa423e8b7768af45be92c2aa544334f46b0b7db1abf8086e23ee2e1b9530c08"
    sha256 cellar: :any_skip_relocation, monterey:       "a98cdc03dad119683f8e3b83b43b5b41becc22f88cfd4d446f6f1e81a91d9259"
    sha256 cellar: :any_skip_relocation, big_sur:        "a98cdc03dad119683f8e3b83b43b5b41becc22f88cfd4d446f6f1e81a91d9259"
    sha256 cellar: :any_skip_relocation, catalina:       "a98cdc03dad119683f8e3b83b43b5b41becc22f88cfd4d446f6f1e81a91d9259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffa423e8b7768af45be92c2aa544334f46b0b7db1abf8086e23ee2e1b9530c08"
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
