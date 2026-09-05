class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.46.1.tar.gz"
  sha256 "af1097f47421fd8480c23aeed2699d5d53ab3fc7cc57c6b8a62e35b34e29bf41"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "40024ff44e751fbd2acfd355c4518fa032f6f38b43a8c188f6a5ea764fc75250"
    sha256 cellar: :any, arm64_sequoia: "fe3b881f87a7ae51729196e7fef1771839fd36467d8ec6528478c92d7e62c8aa"
    sha256 cellar: :any, arm64_sonoma:  "d9fe76c5368af616299fa6ffaa9d1511f24bb91fa579b41063237b6a9bf76cc1"
    sha256 cellar: :any, arm64_linux:   "22e385dd8ec58c69f8422d0c5233e4d553aa7dc1b4f25fb7bc0a602ec856d1dd"
    sha256 cellar: :any, x86_64_linux:  "f340807c9ee3145fdba31b980f1564bcfdd092ab7d0915089e29a872174e724d"
  end

  depends_on "rust" => :build
  depends_on "unixodbc"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port

    ENV["PORT"] = port.to_s
    pid = spawn bin/"sqlpage"

    assert_match "It works", shell_output("curl --retry-connrefused --retry 4 --silent http://localhost:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
