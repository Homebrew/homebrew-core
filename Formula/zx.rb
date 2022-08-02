require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-7.0.8.tgz"
  sha256 "d0334fc256613380ac84441c5d12922615868ab235ca5fa60d34db321eb49a2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5e602b14e44afb3f84842b803a3443c263d48d208827949f77cb288c4d36bcb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5e602b14e44afb3f84842b803a3443c263d48d208827949f77cb288c4d36bcb"
    sha256 cellar: :any_skip_relocation, monterey:       "5a80609b2d1e4a23443946d863abac30b09f0a57c3301b7d605bd1863c0e96bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a80609b2d1e4a23443946d863abac30b09f0a57c3301b7d605bd1863c0e96bd"
    sha256 cellar: :any_skip_relocation, catalina:       "5a80609b2d1e4a23443946d863abac30b09f0a57c3301b7d605bd1863c0e96bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5e602b14e44afb3f84842b803a3443c263d48d208827949f77cb288c4d36bcb"
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
