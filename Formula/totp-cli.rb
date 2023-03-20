class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://github.com/yitsushi/totp-cli/archive/v1.2.6.tar.gz"
  sha256 "ff64b624a9ac5c1afcb8d0ae506439e0e7048db976d4e4940a9e5a0ff7f8e107"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d55ff097af79ea814ab863807ea0da863a6d7f81f7ddeaf52a39626ecb11c0ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d55ff097af79ea814ab863807ea0da863a6d7f81f7ddeaf52a39626ecb11c0ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d55ff097af79ea814ab863807ea0da863a6d7f81f7ddeaf52a39626ecb11c0ae"
    sha256 cellar: :any_skip_relocation, ventura:        "6224212bb66dcde7d63577a68a6c7009f310a098685d112af0570a2bdc86fc23"
    sha256 cellar: :any_skip_relocation, monterey:       "6224212bb66dcde7d63577a68a6c7009f310a098685d112af0570a2bdc86fc23"
    sha256 cellar: :any_skip_relocation, big_sur:        "6224212bb66dcde7d63577a68a6c7009f310a098685d112af0570a2bdc86fc23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c9ebfd82da77e953c0398724cb97ece537458954858f5b51965d027f62b9ca1"
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
