class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://github.com/yitsushi/totp-cli/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "c8b87c7854f373423dba2f8c6167c2836b6ae1f66b29b1becb505c277a00c54f"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f1100b0352e1655adde8916a571f21ab8c0648bb1855a70b85d58536376352f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9515bdef2db3bf5da965a8277124a63896168381b4b137081f0a00aa8f2d77ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9515bdef2db3bf5da965a8277124a63896168381b4b137081f0a00aa8f2d77ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9515bdef2db3bf5da965a8277124a63896168381b4b137081f0a00aa8f2d77ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "65b2d6046eea06c4d909b30fbbc6c63ba549bcd7d11b638f6567bcd938a99b87"
    sha256 cellar: :any_skip_relocation, ventura:       "65b2d6046eea06c4d909b30fbbc6c63ba549bcd7d11b638f6567bcd938a99b87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "917d681477bf4f6ae1ea440252d6ce6afe051b83c81de3df631b5fb93912b0f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17aa04b4b9f66b5ef84c7584f1195cff95d76395cda1a02b5e756f90e5227576"
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
