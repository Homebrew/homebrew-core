class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "1550ef8ee187f2ddf16b182b51716606d7b3e6ba71a6c5007de0a61c94d71bec"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fbb8faaff6ff8031ce45cdb4f902776d91e88e39b4f87fafe8fd594227dda373"
    sha256 cellar: :any,                 arm64_sequoia: "3c3a6a1f2a41528e3c576adb4168aa66a1d0e7d0d84222ffbc16ceee64998cd3"
    sha256 cellar: :any,                 arm64_sonoma:  "5cfc5fb55701ca049f891488cfd8390f14c5a8c9095c6f750607f2bae512068d"
    sha256 cellar: :any,                 sonoma:        "c598d70af92811e6b18177969bcb982fe3e02b7d58e5296e6b30104a8aeefdf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7af59b25dc9825511f9264a2c98202b33f7c37e361ed0780f3c0cc270ea1d36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cced23443e621fa7d01bc67c1bb972219ae96c7c6909385cf7d34158b70e7bec"
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

    sleep 2
    sleep 3 if OS.mac? && Hardware::CPU.intel?

    assert_match "It works", shell_output("curl -s http://localhost:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
