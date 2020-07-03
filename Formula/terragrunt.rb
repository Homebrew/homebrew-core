class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.31.tar.gz"
  sha256 "7bb9859fd968220bcae1908079448834a789fca03d644d405a61441cd4a655a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "c74b848ce18f0e9213060a65ce821780253bb1b5243347ef54a0e1be5340c417" => :catalina
    sha256 "07f2f7c28801f415bc2fa0eb4c12f822c4c54cb43bae78628fd8c8db372717d5" => :mojave
    sha256 "96abd6473924b65e834d33412f2d3087f994f9a368367e79a75b47acec02475c" => :high_sierra
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
