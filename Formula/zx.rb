require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-7.2.2.tgz"
  sha256 "23c580fff7dd49020cf34f3f0808a2c7c2e3a32f80b586b51210bd8f0630a431"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c88584226f18e020696ac6b08a062d22b05cd93c2fa1904ce296a1a51a1c3f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5c6a260e39e7d757a10c10c959293bfc2bb806d0d7bcfa1bd92611ea1e7ef2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5c6a260e39e7d757a10c10c959293bfc2bb806d0d7bcfa1bd92611ea1e7ef2a"
    sha256 cellar: :any_skip_relocation, ventura:        "12a74fec9e69b331af7efdb4e9128bcda681e5f6f7a3aa38e3855f159f5b8019"
    sha256 cellar: :any_skip_relocation, monterey:       "12a74fec9e69b331af7efdb4e9128bcda681e5f6f7a3aa38e3855f159f5b8019"
    sha256 cellar: :any_skip_relocation, big_sur:        "12a74fec9e69b331af7efdb4e9128bcda681e5f6f7a3aa38e3855f159f5b8019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c88584226f18e020696ac6b08a062d22b05cd93c2fa1904ce296a1a51a1c3f1"
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
