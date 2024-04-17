require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1289.0.tgz"
  sha256 "35cd288c8225e2d04d448f951e7503550c61784ba2b8594740b31dea08e290b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ca335491c8624735f38d8af033306b1d6e7f86b9556ab9206f75af164d708c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6455b0304e01ed0ba13e96350716cbd6c0264e791aa4e9800687ab74c94266d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1508c3bdcc121625c5c9eb2335065ecb6357ff154fc8f83ff1208e1d71bccef5"
    sha256 cellar: :any_skip_relocation, sonoma:         "80b3212758422372b008c2956e71b8ff3b5d2a92d11e38b3fead6d937d848e9a"
    sha256 cellar: :any_skip_relocation, ventura:        "11a7457aecb5c811932e0bf04d61ced4ea21a2eae120ee33fca926b2bd33f69c"
    sha256 cellar: :any_skip_relocation, monterey:       "2b4a6989ce395c84eb6b6d357b665d4ef0acbfa393072a3290d4aaf3d018871d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91ccdbf72f49e8b7ac139f9f55bb515a14e40b47e5c36b7f149682f5da2b4be9"
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
