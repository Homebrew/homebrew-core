class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://github.com/yitsushi/totp-cli/archive/v1.3.0.tar.gz"
  sha256 "e80f262825af3c631715535ca8c472a0488e9e93a79ae3a46e4d02aed0048add"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6431ed34b5f6586291ab542aa3e91a170da2ca8dc8801f96645e997a0cee95d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6431ed34b5f6586291ab542aa3e91a170da2ca8dc8801f96645e997a0cee95d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6431ed34b5f6586291ab542aa3e91a170da2ca8dc8801f96645e997a0cee95d0"
    sha256 cellar: :any_skip_relocation, ventura:        "e74fb5d23de58cc1da443a5c7fd7967ebc373414d977735143f933d4cc4546e8"
    sha256 cellar: :any_skip_relocation, monterey:       "e74fb5d23de58cc1da443a5c7fd7967ebc373414d977735143f933d4cc4546e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e74fb5d23de58cc1da443a5c7fd7967ebc373414d977735143f933d4cc4546e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da822ac9eabab8e5875dc0e61735aa2a45dc67187dc39535d38c6ab094eaff55"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    zsh_completion.install "_totp-cli"
  end

  test do
    assert_match "generate", shell_output("#{bin}/totp-cli help")
    assert_match "storage error", pipe_output("#{bin}/totp-cli list 2>&1", "")
  end
end
