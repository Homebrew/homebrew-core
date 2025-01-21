class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "5222e0987901d758d832dbf64b19edcfbcc92eab331ea06a872ab8995bee56c6"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "751edf0dbfe28000a268c1858e5e473e357705b121a65b26c527edba8b7e2daf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28b163e604e5c390c4e650c1d3193b07416f1b5dcfd0cf18330264560d820ecb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1afa0e0817e2a38f8c155c9dabb35503395e35582f8dc38a72c96dfa26e600ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fb961b823c2fb1ba7d5b116c91de054635111286069e3893f24049cddca9feb"
    sha256 cellar: :any_skip_relocation, ventura:       "f3999c04b36a4571b4f9b5090816b1facf0da5e4b277c59fe51dcfb6c317bcf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82d71511cd9fa935c3ed026f343c0823b2c8e0a8f437464fee9895171effcea5"
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
