class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://github.com/yitsushi/totp-cli/archive/v1.2.4.tar.gz"
  sha256 "0451172dbd85ecddbe5faf14fecd7cefab3e8678ff6b8d6f5cb6cfa8d7defa3b"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

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
