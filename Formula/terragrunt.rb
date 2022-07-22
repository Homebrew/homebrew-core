class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.38.6.tar.gz"
  sha256 "22602e5556e8c15b4ac65f1c9b57534f5549b4630ad734d228c1cc929a3e5b95"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87f47e54bd697167fdc8490a117cd7f27c5c00f5f6b87c23f5a47e34bcb866ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e8b051f4713c5a4c36137164b1107bc351e81d30e01db442fa71f5b1fb09ece"
    sha256 cellar: :any_skip_relocation, monterey:       "00fb87b3b2541cadcd7a80225c9a3f097ebab857ce523419460cdc120dd096ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "47ed9b51aae014e4198d8b71352f626a537b48fbbe714e29a3aa0e098c2608a7"
    sha256 cellar: :any_skip_relocation, catalina:       "1d9e9c14c1d4f97bcb09dd257b6a933632a6dd4d9788b81787aff33b935bf907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aebfaa647705da82ac376d8598a2522aeee3de7d8b60913a3fca65a25f9230d7"
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
