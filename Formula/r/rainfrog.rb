class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "0b0717df943d8fe49a0b27cb57f1e741fcbcaa801fc37870762c4403533b09a4"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a8781621b5a28849e1d35517d745bf40edb47db36423743f9efd0babe7f0036"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d3f9d17bb027a119a165b5a9db01b13541b8c75dafdf069918feb5be1c4cf2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04f2cfde9daf46e4ff8e2f0bfd717780b3ebe49f1d4cce6206ca5fed0d7172e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "26e10a6816fcff1172f10b3179c77136f7f0007be7880b72e72748ff40b8865d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d6e642561c05b6f2a52d6c368e5efc667a0ee83cba7cd23cc57ef32045eedc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "883df9e6ade9cd55222ffa8034eac1560948c28c365b0323779f3c896a0e1fed"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/rainfrog --version")
  end
end
