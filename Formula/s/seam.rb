require "language/node"

class Seam < Formula
  desc "This utility lets you control Seam resources"
  homepage "https://github.com/seamapi/seam-cli"
  url "https://registry.npmjs.org/seam-cli/-/seam-cli-0.0.52.tgz"
  sha256 "b4f2e386fc4e12ce402c2ed9bf0bea89cb03fb17cbc17ab9db846280d4187098"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0507728c5edcd0abad38772760046bf3480f1307ab8aa812e4b41f133da46f6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0507728c5edcd0abad38772760046bf3480f1307ab8aa812e4b41f133da46f6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0507728c5edcd0abad38772760046bf3480f1307ab8aa812e4b41f133da46f6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "746e7e717ef35c625359f6133edf4f75098fba03ff7442ec99d7c057ced3e4c9"
    sha256 cellar: :any_skip_relocation, ventura:        "746e7e717ef35c625359f6133edf4f75098fba03ff7442ec99d7c057ced3e4c9"
    sha256 cellar: :any_skip_relocation, monterey:       "746e7e717ef35c625359f6133edf4f75098fba03ff7442ec99d7c057ced3e4c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0507728c5edcd0abad38772760046bf3480f1307ab8aa812e4b41f133da46f6b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"seam", "config", "set", "fake-server"
    output = shell_output("#{bin}/seam health get_health")
    assert_match "I’m one with the Force. The Force is with me.", output
  end
end
