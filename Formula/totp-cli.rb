class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://github.com/yitsushi/totp-cli/archive/v1.2.6.tar.gz"
  sha256 "ff64b624a9ac5c1afcb8d0ae506439e0e7048db976d4e4940a9e5a0ff7f8e107"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c888b1c2ad7d9de48e0e3378431029930d48a77e81ea68221e9a68c3840b9b5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c888b1c2ad7d9de48e0e3378431029930d48a77e81ea68221e9a68c3840b9b5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c888b1c2ad7d9de48e0e3378431029930d48a77e81ea68221e9a68c3840b9b5b"
    sha256 cellar: :any_skip_relocation, ventura:        "38c60c7fe0b6318e95bc93f29a6754955d7a05604c54f1373839e24fc9f8f5fa"
    sha256 cellar: :any_skip_relocation, monterey:       "38c60c7fe0b6318e95bc93f29a6754955d7a05604c54f1373839e24fc9f8f5fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "38c60c7fe0b6318e95bc93f29a6754955d7a05604c54f1373839e24fc9f8f5fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "307f96787051ae761dbffa2ed718158705cd16ecf08b3013bec32496ad3d730a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args
  end

  test do
    assert_match "generate", shell_output("#{bin}/totp-cli help")
    assert_match "storage error", pipe_output("#{bin}/totp-cli list 2>&1", "")
  end
end
