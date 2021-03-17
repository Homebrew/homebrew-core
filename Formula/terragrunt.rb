class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.15.tar.gz"
  sha256 "f6db3948a64fd388e48b326a3a60adde700cf18fa04a5110de887c6d9f19fd10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f9bd20a23edf222029c2103a181bf2e02301bf69fa1331e356048a8343c6ddca"
    sha256 cellar: :any_skip_relocation, big_sur:       "a81ce2dc9ae67961691194f590cf1c40486288344391215f50ac63f2cca5ce1b"
    sha256 cellar: :any_skip_relocation, catalina:      "98ae09df2f01133bcba5d246dd9c681d9dc2e57b4c5f4dccae6c3b521cc86f84"
    sha256 cellar: :any_skip_relocation, mojave:        "31ba17d17eff73380cd4546d64a248f1ff2d7ab3d28af6ae20c0bbbf5c38b0b6"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
