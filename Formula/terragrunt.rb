class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.38.4.tar.gz"
  sha256 "62bb7269e738ebbf7453147fd889928da9be9f15c70901f211339a02dc4553ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30fa27c63cfaab636415ba1c339a8aeb8e83ab81e4179dad647f12a1d5418620"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1d1c1cee35fe76776bb806d88c16951570ab11257dc2861f52f22855b7b53f9"
    sha256 cellar: :any_skip_relocation, monterey:       "5f038f4f033248fb6f578434e6ac01d5e9ddcdd9b768ede28186e38ef1934eca"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c5b38056b4a1dae4596a0eaffa4c7fec55327cbba7f28a7e9e87915f51c3302"
    sha256 cellar: :any_skip_relocation, catalina:       "c4b1086bb2b21523b046e2b070dda30ba32724dc3954e1368ac2594cec13dc57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49cb666a7ac89ca039dbaf40c346f17321408d7ab7324081cd931c21e73b04bd"
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
