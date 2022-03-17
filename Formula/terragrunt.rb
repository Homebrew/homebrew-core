class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.36.6.tar.gz"
  sha256 "adc7b9d651188cfaadad4ab181155e13a528bbff4338144b104c233e5b249b8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acfa92092a289bdb54a19b2e5a8d906af9daa29c16dc3ba40ad7342089301f32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fe7b8a84be539057685b11f27a19bf46da72b9ced4933e713ef157b0c2c0018"
    sha256 cellar: :any_skip_relocation, monterey:       "e8193b8bdde807f83388b1fe1a3d97bf9987f54c564ce33dfe30bbd730949e47"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a4ef29a44e0adcc275238be7d4f3d4838d281c5a8e722fb48c96fa9b66ed0df"
    sha256 cellar: :any_skip_relocation, catalina:       "d54d55ba7b35c9c967ddce45bb53dd0c6870fda63196c174c0beac965727d2f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14eac560677024f5c0559b2975183703ca2c3c40cdd0a70d1afa301cc8cbb151"
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
