require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-7.0.2.tgz"
  sha256 "d7d64f7c41713f12570950c91534b895749dbbe677c6d2bb3f04d0effd432686"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bcac05e48bce175cac36d3c9665c03f4261f8b459c7596366cd5091385237a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bcac05e48bce175cac36d3c9665c03f4261f8b459c7596366cd5091385237a9"
    sha256 cellar: :any_skip_relocation, monterey:       "05b956950409c016507029ab5e3c52f77a986d7f7afc8be4e693aad76de6956a"
    sha256 cellar: :any_skip_relocation, big_sur:        "05b956950409c016507029ab5e3c52f77a986d7f7afc8be4e693aad76de6956a"
    sha256 cellar: :any_skip_relocation, catalina:       "05b956950409c016507029ab5e3c52f77a986d7f7afc8be4e693aad76de6956a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bcac05e48bce175cac36d3c9665c03f4261f8b459c7596366cd5091385237a9"
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
