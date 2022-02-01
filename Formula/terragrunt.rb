class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.36.1.tar.gz"
  sha256 "697587bbaf33e3248a8cc8565bcfdb9c80a976721aa42145c8b04cde1433b41c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72afa3096779dcec769ae7214bf176ff328f4802d37c393f6bcb151cd5cb6291"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fd2619d5b38b14d0793ffa907b8e584723efc407313b6aaffed9ee99a49d492"
    sha256 cellar: :any_skip_relocation, monterey:       "41f309e2625d2158ba07f35e0ad2cace56b6c8b345120c5b9f83b5bda0a2c69b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1f83b22661d19fa191eb89e9dca47dc80f5305a8e8a945ba8bfaaf3ac358a50"
    sha256 cellar: :any_skip_relocation, catalina:       "67a2b6eded9300db96e3bb69178632b6946f3445f5d81b6d769595f3afbd05c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75921a9ce1d27ddcc10b17d71e520061f63a9ae28830e78f5ed0ea9c5aaf2e29"
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
