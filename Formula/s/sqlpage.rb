class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "85f214f72633a5e24d36038215fafa8e3dadc297cb17a216bceea73f5f9a77e8"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1d6eb60cb0a1a8197821c8e531118b98d285e6a1742efc45ff043e922ae8f6e9"
    sha256 cellar: :any,                 arm64_sequoia: "f2b07e4e69735ef075c662cf5a62ab17ca54b11e62946c6a112d34951a3612d4"
    sha256 cellar: :any,                 arm64_sonoma:  "1b5046b75c0ec1ad07daeb0338514e22b5d73ffaadd86beaa9752ef8900a2e16"
    sha256 cellar: :any,                 sonoma:        "ccd4ffe92e6879322b9bb583b9e1f10b5ff362fed14799de7c957dd05bf519b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32cbc0f1d4aae55b2df8dfde654852ea235d07aca87012bb20748283f554fee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e637baa0ca70803a3c4a8e510975510f7721ad76fc9d64c0cc781248b6d422e6"
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
