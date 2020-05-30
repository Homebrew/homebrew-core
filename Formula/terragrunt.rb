class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.23.tar.gz"
  sha256 "16c3141e7edf93dbd1fdddf42e95f14b0df0ef6db79fad905ecb78ad5105caa2"

  bottle do
    cellar :any_skip_relocation
    sha256 "6129333c46eb2d723932f5100dbde85696a264ec6a12c8b9c66c7166fd3b5b56" => :catalina
    sha256 "d187a8ab14db98132e0f6fd7a19589bbc93d0c0122c95e050a3fea965ffede46" => :mojave
    sha256 "6ffc2430c6fcb03566b68c17f2a1c93ba0293273947443e8a247f7da69c17e23" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
