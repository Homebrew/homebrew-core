class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "03b7239e8843f2db3aba700589c4420b73756035e9da512a7a277265c33bd5d9"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dc4f975144b955e9cb55ab2301b107f75d9726c81574cf0df6ec010b667091b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5beb794ed9cb758662ba295f7ba962a776abe22dee326a4f82273f0e515a9c9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3e8d80a67f5904cc28fdea21770cc1112df991e7c02ae3615ce8680017790c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbebdcbd56c0612604c749a2477e2cfc1aeec7be717dd25e6d7980e6fce9ea2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b006c0c8982d0e148ad61721a83f717615855c2029ab29ad52cc523f8b11269"
    sha256 cellar: :any_skip_relocation, ventura:       "063883a18454e1081a1759a9a51c011c77270692625766304a11ecc5b49266ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbafeb7e8ef0727f36f91e27ed6ceb6eb14cbec21aaad1381b1100b9a7feab96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b9dff43f1f28c5ae671759c4ca7806913458fa8ec26f2e76d48c96fdf4cb665"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      ENV["PORT"] = port.to_s
      exec "sqlpage"
    end
    sleep(2)
    assert_match "It works", shell_output("curl -s http://localhost:#{port}")
    Process.kill(9, pid)
  end
end
