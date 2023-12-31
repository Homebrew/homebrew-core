require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1266.0.tgz"
  sha256 "7a113786861bfe8426a0253b24334278f52c097ad74a6c18dca431142cdea96e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5c5dd1642478068db01f28dc2a20ee5d439a88ada8e474f651eecd49b3c89d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b1af3afb058aedb7ea64bac5f1e9ef0301af8adef927f8ecea6476fa3999a73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3234d6212992af71a80b14ba0d37f11ea6440d3f59d9cf7fe65fdc2b69a8c951"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca2ab70fac614a01a3acc1316c8367f98a2b945160f7f769f875ca7edf292ab6"
    sha256 cellar: :any_skip_relocation, ventura:        "5a45d4fd256e33be475d39da3fc9fa706c13d791603e985ace2d71a916425c02"
    sha256 cellar: :any_skip_relocation, monterey:       "2d62c27e0508424a5216e96f061ae230ec46e27bfd9878f7834b1230c522c8bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aa817f6a32e1fa7a25fdbeb18dc12d4a195e5b63f4867e1a98ffe2e55389fe5"
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
