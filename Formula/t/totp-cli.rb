class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://github.com/yitsushi/totp-cli/archive/v1.5.3.tar.gz"
  sha256 "991d42b50b8aef845403a785a84b38c500cf62659577dd31e424bd2428c51379"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58a74f128167caeb6f13d4acfa57b71bd36703903fc0dfa3ba3ba52723c45e2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c740404371a25a8323c3cb902bae9ced9543b45c87bbb48b3c2f8789d63f3f17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64ddaff9046cdd19dd9beeb6951daaaffe91c8b8fc3523f9f7b03addb301fd6f"
    sha256 cellar: :any_skip_relocation, ventura:        "046754fb6ab1fb9b997fb0067c396d6c05ad1bd40a503cca3a8ae920151fac66"
    sha256 cellar: :any_skip_relocation, monterey:       "8b0f624e2a97cc6d6d4f4825271eed7ec1835259ebadb7bb492806223aeeccd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "647e8a29fb4f6964cca0ec94f0ec5e533f989febddf8d30004bc44fdc6b30304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41d0252cac89538d72ef1333cf4390399afe597a8eb33b53b45f90e4ec88547b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    bash_completion.install "autocomplete/bash_autocomplete" => "totp-cli"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_totp-cli"
  end

  test do
    assert_match "generate", shell_output("#{bin}/totp-cli help")
    assert_match "storage error", pipe_output("#{bin}/totp-cli list 2>&1", "")
  end
end
