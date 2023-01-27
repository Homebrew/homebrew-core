class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "ffafd7e611945c8f786b093c9edabf1902ee63ea7c04031c0fa93360ecc619ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f5b5a26a6583e3615da7cd403904787a709c71f4ede15d6001cb1b3820b974e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc57a8dbf5f4836620500e77bf3f2b4ab7355b1500094c9a6b5a8607b6be990a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9293d60d76fa4153000e1dbe549601367da3b8e94c09f0beff961d4e9e0b7f5a"
    sha256 cellar: :any_skip_relocation, ventura:        "acdcc8366eb5b5a2bf2ea2fbbadaef86c2531eda8c62f2fe753838c00ea5e649"
    sha256 cellar: :any_skip_relocation, monterey:       "f7d27429bb9fcad5d2a612570d63ee6b71260c1b6f5be0459cdd47f638a5f1d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5de0ef0f813a9cb40417f41db11553f628cf2b17a0e79e27c32696e6d4f8af66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21722fbaa51e1b213a140b68b9427892d5e00fc0d56ed574edeff5c705925735"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/modern"
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_equal "sqlcmd: #{version}", shell_output("#{bin}/sqlcmd --version").chomp
  end
end
