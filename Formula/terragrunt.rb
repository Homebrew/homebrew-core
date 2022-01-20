class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.36.0.tar.gz"
  sha256 "46e726ac6c38588ef0f98bfa69d01c3e1ea6425eada3b7b86b89110bfa516a95"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09b30186d71849d8a28428b30483bee934e1177139509ed5015a9495dae5bb85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d52843b2776f1025650fcaf5dd4f98bb6c3fc244612cad4c2b993800931ddb17"
    sha256 cellar: :any_skip_relocation, monterey:       "64a862774c065c830d5b27340009bc5f2e1b43e06b37382dc2c85eae7323b161"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb9a8c9039af88c53c2f2df1d657bffe50f97881ec36698a900ce085c96bff48"
    sha256 cellar: :any_skip_relocation, catalina:       "50de7aaf4645f122efa15b48b9307268627880f38de5b9d8c245beef4328618f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ab95e6008cfdbb01edba949a9fce1801ba501f2651ddc2da92464d22f98b1c9"
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
