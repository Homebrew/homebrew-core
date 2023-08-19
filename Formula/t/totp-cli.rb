class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://github.com/yitsushi/totp-cli/archive/v1.5.0.tar.gz"
  sha256 "6d41bf991d28124f1a1f424e8ab9df0f22bfe8699257eb39d1bc2d293c52aa47"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48d427b25e62d63cb289b39d06da7f45365ad91b0fe821fb8275fbeaf67b26c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48d427b25e62d63cb289b39d06da7f45365ad91b0fe821fb8275fbeaf67b26c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48d427b25e62d63cb289b39d06da7f45365ad91b0fe821fb8275fbeaf67b26c0"
    sha256 cellar: :any_skip_relocation, ventura:        "ade20b48448f2756249d8a1c0f6c9d65dc733f62439bf5eed0ea0301ea2d77e0"
    sha256 cellar: :any_skip_relocation, monterey:       "ade20b48448f2756249d8a1c0f6c9d65dc733f62439bf5eed0ea0301ea2d77e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ade20b48448f2756249d8a1c0f6c9d65dc733f62439bf5eed0ea0301ea2d77e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ede933e250f90ff8727a1eeeb2e0cf6893deaf57fcf588e8888b5984125779d7"
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
