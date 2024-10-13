class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://github.com/yitsushi/totp-cli/archive/refs/tags/v1.8.7.tar.gz"
  sha256 "d23554e785323cc6d4145b848fe140621f9bb6fc8809280235ed5f7aeb92e5fd"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cb0fc63e67ccb68a771ca2a3b045bfc085392e39649e2aceed871f592384312e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "639a52e26a4fe096876d49c21bb486fc180af52e420cca8d04144d0d6edb5bbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "639a52e26a4fe096876d49c21bb486fc180af52e420cca8d04144d0d6edb5bbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "639a52e26a4fe096876d49c21bb486fc180af52e420cca8d04144d0d6edb5bbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c333a8962572dde76230a73d35a892d60e4f3f63784663a6abd2b2917b5e669"
    sha256 cellar: :any_skip_relocation, ventura:        "0c333a8962572dde76230a73d35a892d60e4f3f63784663a6abd2b2917b5e669"
    sha256 cellar: :any_skip_relocation, monterey:       "0c333a8962572dde76230a73d35a892d60e4f3f63784663a6abd2b2917b5e669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5d08e28099b6ebb9af6afed9b168c289a35a79c633b2027ef82adecb95850e1"
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
