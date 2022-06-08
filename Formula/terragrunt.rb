class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.37.2.tar.gz"
  sha256 "97d169a673c002a9aa799a10d2eee46180e13bd8f5031096903581d9c6c25def"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87a2ad21f5503f969811a897d7ed15c806c853fdff12993c665becbd13a9f850"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1e4557e027330e7d22ada043d78b25bddec2f6dcf391a9ac5878018e9120656"
    sha256 cellar: :any_skip_relocation, monterey:       "49964e0c0f7391778d2999cd7545b00f8bd77a9196e80c852cb6c100441bcc51"
    sha256 cellar: :any_skip_relocation, big_sur:        "257f977769a538d669d0017752373c081d124b7fa8d0034ec56620c5c1a37e86"
    sha256 cellar: :any_skip_relocation, catalina:       "50e7338ec0b242bc613be806482e0f01cf0d73330e513cfe7f1f556dc16e2d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b17df477edfbb539226e53156e501d2585e792d9a6b30a2ab071af4447a129df"
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
