class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.36.5.tar.gz"
  sha256 "d26b2e62fe763d2924a3edddb1caba367e023eafc3c55a1c4f666ca21241bc3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b59d35495c19f11f4b08ed16a2794e7f2e5e076d86c02ecfeadb4f15fc6e457"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e7fd819bdbccefb219f67dc085e0a3e347afac5432e4b1c2da2f6d4eefacd8c"
    sha256 cellar: :any_skip_relocation, monterey:       "f052462e729914b82a267298e4ab2990dd941f8deb229905dce69884190e93e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ac55a01bd524e6680c1e4b11875ad3c341ae70223a0d8592d5a2363ee4c368f"
    sha256 cellar: :any_skip_relocation, catalina:       "1e3e9980cfb6894ec88f8a06ca597793bcf0606882b73d9369856f622b3b2372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60977eede4778767e34ed05db82ed8084e193a09e681ef45085a16dc7602931c"
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
