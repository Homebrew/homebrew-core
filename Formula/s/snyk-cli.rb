require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1280.1.tgz"
  sha256 "1d38977a47850fd5fd360d5922a739d92e6facc4b5de24bea1b7a935065d8052"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a594023d761329b63984c750e9ba5cc0ea10f1fdcb1079c9ce4c82b0f845a0a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a3287f17e7edd1532b7fcc8ea0b69bf2a4d6da123302dda9575b21c85713a9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22c93a4b92df8ab3cbf9019635447cbe0fd4f4596cd6e6380ec99c20b4a5456c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e15ad24c803fe3c6c2fa681d37ee5943d0526dbad84f20f66578755d386cd595"
    sha256 cellar: :any_skip_relocation, ventura:        "3fc60afdecce340d3f96aa239a6c49c3612c0ac87c84760e664c1216234b0d13"
    sha256 cellar: :any_skip_relocation, monterey:       "8a250dd96751db1a123d199e8e84fcb6cf921772672f832615835b1c21f1ebb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d42cd5f0a15f1389466156f6ab29e36357f22e24720db374f05bc4809837244e"
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
