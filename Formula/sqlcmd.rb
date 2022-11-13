class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "718f2e770d4b2d04521b4988c6e353d0b8df4a559582da3a3e8627dbbbdd8c40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f8ce37a16cc727356faa80f57d2f05f919f1afa31b012e07d26c4de9afcce9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f522588f31fce97b48872a0de9e46e530be933e34a4efdecea30fb3019cb8ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f522588f31fce97b48872a0de9e46e530be933e34a4efdecea30fb3019cb8ba"
    sha256 cellar: :any_skip_relocation, monterey:       "046a8193b10eba6081c4ad1e95167d16c451ea675777ba7685496fbe9b734e2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "046a8193b10eba6081c4ad1e95167d16c451ea675777ba7685496fbe9b734e2e"
    sha256 cellar: :any_skip_relocation, catalina:       "046a8193b10eba6081c4ad1e95167d16c451ea675777ba7685496fbe9b734e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4bfe0c85b2f981a6516a83d6ea9d242129625096b290e83e19180242b237c37"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/sqlcmd"
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out
  end
end
