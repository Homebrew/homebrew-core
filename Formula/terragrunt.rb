class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.24.4.tar.gz"
  sha256 "8241279e0301745dbb079d6e9c994b404e7c15c5a594316d94bdb5b5c2f48358"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "209a7623cf46c0e429ee0a9473b9e28dce23389d1ec8b4c5db1bb8e533f0707b" => :catalina
    sha256 "5763e7711b2a65d7bd513f1855e5d6ba7bf723f0a0dc13b6a241a925c9293915" => :mojave
    sha256 "2da211411cb2d076dd97eb451551dc17ea2cb77e609d5b1d870320562e7b1eed" => :high_sierra
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
