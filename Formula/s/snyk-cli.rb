require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1238.0.tgz"
  sha256 "4808ee5a7705392fc660387bbdf4561e0375f3b3f3cf82bf83663d9703e43acc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f040b728d524968a0a56b953a1f3b209b3beb87951d76b3cff22c6d0c5fc3510"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b3c2fe1eeb8f1fd885e44b0d261a2149c14ab842efa5d542c42f408c092036c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5e2364d974c3f16e56c4a054f9c0478690bd1e5b164f9213c35624b374328a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9caf92ea77f57ac2939423d754cb5749da1fb4c02a80312bde905fd66c3ca0e"
    sha256 cellar: :any_skip_relocation, ventura:        "a54c77cd1f6cebc83f739dd28b6147296997aed8817a400beef87cd0da6a1717"
    sha256 cellar: :any_skip_relocation, monterey:       "fe47e2b5f9c837d04f8552c2c788a6682671f7d092039d55292616c9df55a30a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c4f82dd2bc7cfd77548fa18da95ebecd448c859a68e5177a6e8fd30a114a033"
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
