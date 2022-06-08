class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.37.2.tar.gz"
  sha256 "97d169a673c002a9aa799a10d2eee46180e13bd8f5031096903581d9c6c25def"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a36bfde6942b1ec15cf351fc75791fc56786b61731e43cd16b4f60145b0f164c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21150e74ae17591c03b69d07ed589689f0822fd39b9ce743586638c53b229c9f"
    sha256 cellar: :any_skip_relocation, monterey:       "5b57841de9140cb387df5133d5803b7c0662166c34440287ca64f2c574ca725f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4e30c6e4218d469fe20d305769641d2c74afd16cd29d422bc60f8486919b9e7"
    sha256 cellar: :any_skip_relocation, catalina:       "3cb5a38a6b8a2b188404e3078d662e3eac98e00bf1fd11546cdc0bed4dbbb31b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c597e785cadbff9ae52a6f434e79d4479a9b6aef78a369a7114a4dc974a034ec"
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
