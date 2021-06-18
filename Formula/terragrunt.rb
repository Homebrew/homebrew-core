class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.30.6.tar.gz"
  sha256 "927eb56c6b4ceca4a6cac145c559505df7a3e3ff45655fe89de8a0fafe0c60dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1add679fcf0a65b3fa18966b44106e4d7f2784e463bf32858f49bf1a503d17c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd900ab4665e4698ca465fb4c32f7985406916b821b7b5f1aef57fea5e20a506"
    sha256 cellar: :any_skip_relocation, catalina:      "933fe5f2cd056ae7181b5eef52280aa2626aff44a72defd844390b307251512f"
    sha256 cellar: :any_skip_relocation, mojave:        "e295ff610b64ba072ded48375ae6fa0ae35055271641437bb7342095563788a5"
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
