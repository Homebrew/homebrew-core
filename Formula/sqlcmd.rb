class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "1eda0cbec26cc3040da955e6ff327fe8019f25a7e7462c7bb53c2c5a5b750578"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9fba4a3404f3ebd96259dadd9de504c5b993b0785cf34b54fc79d6eb03458b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9fba4a3404f3ebd96259dadd9de504c5b993b0785cf34b54fc79d6eb03458b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9fba4a3404f3ebd96259dadd9de504c5b993b0785cf34b54fc79d6eb03458b6"
    sha256 cellar: :any_skip_relocation, ventura:        "5f3c59723b4487cf5a19081180b34d55fd2ea3d66de4d2ac8b38aaf0dca77f35"
    sha256 cellar: :any_skip_relocation, monterey:       "5f3c59723b4487cf5a19081180b34d55fd2ea3d66de4d2ac8b38aaf0dca77f35"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f3c59723b4487cf5a19081180b34d55fd2ea3d66de4d2ac8b38aaf0dca77f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a98822411e7401a7aa3e527d8a81bacc407e8e69bed87041ec6d3129d806e1d"
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
