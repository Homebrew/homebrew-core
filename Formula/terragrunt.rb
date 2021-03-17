class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.14.tar.gz"
  sha256 "c88eabfa42e79cf0eb9d1b6b88393cbc58f5d5ed5fc3409bd648bd2dac27d181"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f9bd20a23edf222029c2103a181bf2e02301bf69fa1331e356048a8343c6ddca"
    sha256 cellar: :any_skip_relocation, big_sur:       "a81ce2dc9ae67961691194f590cf1c40486288344391215f50ac63f2cca5ce1b"
    sha256 cellar: :any_skip_relocation, catalina:      "98ae09df2f01133bcba5d246dd9c681d9dc2e57b4c5f4dccae6c3b521cc86f84"
    sha256 cellar: :any_skip_relocation, mojave:        "31ba17d17eff73380cd4546d64a248f1ff2d7ab3d28af6ae20c0bbbf5c38b0b6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
