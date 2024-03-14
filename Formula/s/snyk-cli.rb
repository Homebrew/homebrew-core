require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1284.0.tgz"
  sha256 "2b792172cc61315076206962405a51e15b9b982863d88f91a67a9f0779c4b604"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc40817e7768381331bb4ac06101bd3ed1d792f04e9844afa41315dc71d9237e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c19bc9e33e4e4aa82f9babda12344e01d9fb9495c46a8d22c56b54a45a8ad41c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bd37af9a8c1f4db74162f4653ae082cbdef806a6f5e37c85d1d4a6adc4f3560"
    sha256 cellar: :any_skip_relocation, sonoma:         "36991007396889a8b6bdfb25030abd7733f724a295d63e47b7fddee273bbf257"
    sha256 cellar: :any_skip_relocation, ventura:        "ebcb5e1f7ca17f2361cba5be2d292af83f8a7f9ff0eb57740bc3bcc582edb033"
    sha256 cellar: :any_skip_relocation, monterey:       "feb3ecfa30cf7088ce2986f555c6de5e21dcecc5647678fbf853bac6168f4fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5e071f6c1db0daa11e6220b045017ff56c3c0867b4b8789214687463b3e1bfd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end
