require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1291.0.tgz"
  sha256 "a68929ab1357a336dbae5eea8d4fd39e2ebafee25cf5124de5eeaa508dd06266"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a223ffae991a6f09c53a56f3264f3177cc35d1bcbf261b03909f357cabd46c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a223ffae991a6f09c53a56f3264f3177cc35d1bcbf261b03909f357cabd46c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a223ffae991a6f09c53a56f3264f3177cc35d1bcbf261b03909f357cabd46c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a11dd3d8b47636e21495d7752b8332aadac7dfc7547559fba4174ea7eccffc1"
    sha256 cellar: :any_skip_relocation, ventura:        "4a11dd3d8b47636e21495d7752b8332aadac7dfc7547559fba4174ea7eccffc1"
    sha256 cellar: :any_skip_relocation, monterey:       "4a11dd3d8b47636e21495d7752b8332aadac7dfc7547559fba4174ea7eccffc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da2527ceaae10a886b3cc5746faa4fe5e7a06bf4fcc3b1e1764aabe8c06d8a2d"
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
