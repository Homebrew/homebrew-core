class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.5.tar.gz"
  sha256 "b6c221311a2092b61f281e448d6e0ce7e953c3e2cb0deab646bf4f68884f30d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f70a735317b84e80544db228a0c21dab580e79b765d097493063abef2b2a97d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f37f43ba483f6d88a00b3542c425c685bafbb0976ad333ccaa261e3ca1a65700"
    sha256 cellar: :any_skip_relocation, monterey:       "f6abc4e32ffdd9d7ef14eabe7923d94a32c36dce5a2b811a2d9070caa9b92c20"
    sha256 cellar: :any_skip_relocation, big_sur:        "e65387285dc98bd882d288a743d49246300f9c42afc2562d1c88bee0c11f27ed"
    sha256 cellar: :any_skip_relocation, catalina:       "afad6878ef5cc58bc106196850ac972aefc0397f72685bcdedfe83ea460083f0"
    sha256 cellar: :any_skip_relocation, mojave:         "9144da54ff3014698c494951beab6dfd3d7508af9b4653aaaf559239cc7eab30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "600227492ecbd37e0e6d5f6780b64cd5f7e5da607fd3f69b56d8227c71b42fd2"
  end

  depends_on "go" => :build
  depends_on "terraform"

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
