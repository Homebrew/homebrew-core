class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.38.6.tar.gz"
  sha256 "22602e5556e8c15b4ac65f1c9b57534f5549b4630ad734d228c1cc929a3e5b95"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a67fc9934700064557947f6917233b25eefbb22fcad5037e2da91c829a19ac5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a27ba8bd343bc2accb6a3cb5e800dd4e8e104793c49f934bc69772a2ed03a529"
    sha256 cellar: :any_skip_relocation, monterey:       "98d42ac51fbd86906aa2b3978739fc498b711dbdec2c92dc06a1f7b2a6799440"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed4c3c21e4cbcebacb5f57ebfdd75f607dd87e34f3a9e4ddd8a34bb3f1b4074b"
    sha256 cellar: :any_skip_relocation, catalina:       "b343b74f8cc5303eef100bf94245a3a0c3da023ea4db8f107a8e6a3ee45e8c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bab7fae7b29d833b2cd6978b6695fc9a4e6a754c1236dc5f9859b40f33bc96d"
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
