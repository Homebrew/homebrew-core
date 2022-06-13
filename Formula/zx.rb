require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-6.2.5.tgz"
  sha256 "dab8b8090c98bd11a71af427eb34c2221070e5e176aaef882141cf700fd306fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91d34d483bf3a78476f8a8fcbc8740882ee6674da4126ace9dce33595ec89b17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91d34d483bf3a78476f8a8fcbc8740882ee6674da4126ace9dce33595ec89b17"
    sha256 cellar: :any_skip_relocation, monterey:       "fa12954fccf750ecdfd04f6ad36e4d2458215503472233863e1d3bd14cccf293"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa12954fccf750ecdfd04f6ad36e4d2458215503472233863e1d3bd14cccf293"
    sha256 cellar: :any_skip_relocation, catalina:       "fa12954fccf750ecdfd04f6ad36e4d2458215503472233863e1d3bd14cccf293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91d34d483bf3a78476f8a8fcbc8740882ee6674da4126ace9dce33595ec89b17"
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
