class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://github.com/yitsushi/totp-cli/archive/v1.8.1.tar.gz"
  sha256 "59d403db99b59ba6ccd25d20b6232c8c4edc35d8f1f2a3681ca4a9db1a13c9e3"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fc576846b200064249e5a5e0999778fc0e18f8c866bc234f4ec842d97edc105"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fc576846b200064249e5a5e0999778fc0e18f8c866bc234f4ec842d97edc105"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fc576846b200064249e5a5e0999778fc0e18f8c866bc234f4ec842d97edc105"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e5439787f881b28a7fd6bc57866b77f11fd72d4a07507189f00201f8864aa78"
    sha256 cellar: :any_skip_relocation, ventura:        "0e5439787f881b28a7fd6bc57866b77f11fd72d4a07507189f00201f8864aa78"
    sha256 cellar: :any_skip_relocation, monterey:       "0e5439787f881b28a7fd6bc57866b77f11fd72d4a07507189f00201f8864aa78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42a7056e0379b41e746ecb56da1ebe53cba65fabca41272fb13b892176081ae5"
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
