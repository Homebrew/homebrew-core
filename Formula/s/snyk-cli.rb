require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1280.0.tgz"
  sha256 "e4f90f9b64b659a8c028aef56f184273ab613ba1f67f1678a8f798dc3e37609c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "820a760ebd22ea868baa6b082416396434c4a82c68b15e786bd01282a06c64a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5860b572df9fcd9139b74145a044e7e8296b2df01c5c2e19539d307d0f1ccc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "983fdbb1a2c8d191671b49e27731135fc10e14262bb03a0f27bc87de7135be31"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a07a94a2c7a295a41cf93c8ddfe12d2150c8fc2aa01d5366c30b23c5144105a"
    sha256 cellar: :any_skip_relocation, ventura:        "c86892a2d7865e4163edaaf24901690deba783e7ebb071d5b21f98d8383238d8"
    sha256 cellar: :any_skip_relocation, monterey:       "9ae75603f88fca88c479e5ab3cedcaff43299769da726f84fda74ac183c483cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a7437dd3c57a8115bae5090476d896e0dc7c7eb743a8cd2ebb0f8512aa0a23c"
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
