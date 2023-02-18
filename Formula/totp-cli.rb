class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://github.com/yitsushi/totp-cli/archive/v1.2.6.tar.gz"
  sha256 "ff64b624a9ac5c1afcb8d0ae506439e0e7048db976d4e4940a9e5a0ff7f8e107"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23e731ae57f502b192462c648f3050be7da008684242dcc32ffe900064aaf20b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23e731ae57f502b192462c648f3050be7da008684242dcc32ffe900064aaf20b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23e731ae57f502b192462c648f3050be7da008684242dcc32ffe900064aaf20b"
    sha256 cellar: :any_skip_relocation, ventura:        "6fbe20f89fbda452c97ae016202fc148bec5f29afdc15dfb287d5d200460c290"
    sha256 cellar: :any_skip_relocation, monterey:       "6fbe20f89fbda452c97ae016202fc148bec5f29afdc15dfb287d5d200460c290"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fbe20f89fbda452c97ae016202fc148bec5f29afdc15dfb287d5d200460c290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8de84eebe6022c9589d8454a024bd84e48d10820b9dfd058d4aa669fb72498b5"
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
