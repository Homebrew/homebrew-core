class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.30.3.tar.gz"
  sha256 "1b4e1949dc3e34b37da8e7cde239fa13335f06e0ef777f9e30d8363de7c05a2b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "35acca5fbdd15601c3643f5edec30297fa3281131fb28ce1a9526226e90e036d"
    sha256 cellar: :any_skip_relocation, big_sur:       "03d081e51ed0ac436278f934f6de83092cc73ecae3a894d2124082e144f344f3"
    sha256 cellar: :any_skip_relocation, catalina:      "653ecc5a8029cd5cbaf0f7921322621298e8beb30eede28548b3f626cdbe07a0"
    sha256 cellar: :any_skip_relocation, mojave:        "8591336a0bc05867b08e3de58dd59817e005ea7a3e1002b51af136dc76f93ec3"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
