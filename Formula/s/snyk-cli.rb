require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1285.0.tgz"
  sha256 "a86b8f193722a9ff384d886eb0e9c63031e426325116d2d06b43273ce27551a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c9ed6ea630bf4b8f7128d32be88a0271f07fa879a69b13bfcbe49fd2dda9762"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be074b4c0fa5c02bfbe72e64fe0612927a4c05df356a3d044fb94b4380c3fa14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "843d7b09671db73783fae53cdde2ec2f8d36c2e4a8b71bac3f2d7326e50769b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0bf1267e6f8d0f00822908b9b82b432bd2763e1f1c9dd935ee17741a4991a9b"
    sha256 cellar: :any_skip_relocation, ventura:        "21ed89e297a543b7d189facc0855548d42c94279a5255d36ed57771e2be29a18"
    sha256 cellar: :any_skip_relocation, monterey:       "60ace374114855068691b8e3020f5a9f9a360f54b5ef067baf997f1857538095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eb0a591ef2d2ebbb3edb24d02a6465644066fbf0de24074ce96410c15d62293"
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
