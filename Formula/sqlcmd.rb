class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "718f2e770d4b2d04521b4988c6e353d0b8df4a559582da3a3e8627dbbbdd8c40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07e962f035bd8ae6ad6e1acea1ea1d715575adbc5e0dc2d5e9c9243ff7088c77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07e962f035bd8ae6ad6e1acea1ea1d715575adbc5e0dc2d5e9c9243ff7088c77"
    sha256 cellar: :any_skip_relocation, monterey:       "721717dbed76e3641c24fafc1e78d05163f2f6d05bf24511a8e6235a78750b94"
    sha256 cellar: :any_skip_relocation, big_sur:        "721717dbed76e3641c24fafc1e78d05163f2f6d05bf24511a8e6235a78750b94"
    sha256 cellar: :any_skip_relocation, catalina:       "721717dbed76e3641c24fafc1e78d05163f2f6d05bf24511a8e6235a78750b94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c20233f6f68b56ab90c7c9c664cdcd7899ef4af654779f100797533f5568b1f4"
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
