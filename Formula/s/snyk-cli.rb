require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1283.0.tgz"
  sha256 "0e071c18fa785c88b7f8fe961fc85968ab7cb16d5ca73982f15e115960391eda"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "daf8e65ee40a8e01f52131de2b885a68367a95ff337af4365129fc66c83d9e0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "335d41ca77db46f5fa441989a66325828c28c137fc41a3c291b0fc691361bf38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "590af1fa9675451e45b67653de16a4d8abcf9e676463c0c1cf0307029d396641"
    sha256 cellar: :any_skip_relocation, sonoma:         "504efb71d5124fd5fe765bff71241c9488ed237788b90a665114a2a0dc8e3057"
    sha256 cellar: :any_skip_relocation, ventura:        "b7bdb2709a145683769e0addacb4ced154e38faca946e4ba96c71079861abaf3"
    sha256 cellar: :any_skip_relocation, monterey:       "fb723d03d4a68e19decffdbfa15a0016a3b3f3f65b6f4a56a8ea646e312c7382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e89f8304d7b044121fd1b9056b949025e5aa9228d32163d625f022ca5c867e19"
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
