class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://github.com/yitsushi/totp-cli/archive/v1.2.5.tar.gz"
  sha256 "8fae64e9d76dbc50553682ccb0c99cc0f70c52cb56710d1423215bb2f5f6b58c"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8253cf4a0d4a3454ccfbefd62636d561fc68af0d51ab4c231f6496f075a8c5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8253cf4a0d4a3454ccfbefd62636d561fc68af0d51ab4c231f6496f075a8c5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8253cf4a0d4a3454ccfbefd62636d561fc68af0d51ab4c231f6496f075a8c5e"
    sha256 cellar: :any_skip_relocation, ventura:        "c0e5f2d9f95bebbf9019e35147c6d3fb57169b1b553eb749a36a0273f4b85fcc"
    sha256 cellar: :any_skip_relocation, monterey:       "c0e5f2d9f95bebbf9019e35147c6d3fb57169b1b553eb749a36a0273f4b85fcc"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0e5f2d9f95bebbf9019e35147c6d3fb57169b1b553eb749a36a0273f4b85fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c75fd7c2487a65604209d70578610dc7c24e111bc01228799ceb5a45d7996197"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args
  end

  test do
    assert_match "generate", shell_output("#{bin}/totp-cli help")
    assert_match "Password", pipe_output("#{bin}/totp-cli list 2>&1", "")
  end
end
