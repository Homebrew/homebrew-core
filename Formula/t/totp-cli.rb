class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://github.com/yitsushi/totp-cli/archive/refs/tags/v1.8.8.tar.gz"
  sha256 "3fe158259b845ff5e957a2d26b290a7474b6ce63dadd52e1046f697991b3924c"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3fb44e2dc96600996a071d09b320d9433b86f223dd4db1d5d78a56cd77067bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3fb44e2dc96600996a071d09b320d9433b86f223dd4db1d5d78a56cd77067bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3fb44e2dc96600996a071d09b320d9433b86f223dd4db1d5d78a56cd77067bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "37cfcee16c239ee82285f7f68f5137d40b77277fa4b84506b50fa7b73b848d57"
    sha256 cellar: :any_skip_relocation, ventura:       "37cfcee16c239ee82285f7f68f5137d40b77277fa4b84506b50fa7b73b848d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72045ef678c09cfe94ca044cc7ae8057bdd2a79201abc15469ef7f0e6be11ae8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "autocomplete/bash_autocomplete" => "totp-cli"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_totp-cli"
  end

  test do
    assert_match "generate", shell_output("#{bin}/totp-cli help")
    assert_match "storage error", pipe_output("#{bin}/totp-cli list 2>&1", "")
  end
end
