class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "17d3936c7d8cbb9498bba268964125d51a354801808181c4a58ef8c893a37ec4"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b23eb0fe85ba746cef41cd07afd5b83c4d9179445401cf325b980dc5557c980e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56a7222f69f960a0eb041f2d7e9854b07d29711aa8c2c832f9a55923269a8674"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7d32f966d91a96447dddac267c06bfcdc951aaf38f14bd25c93d8f93c5247d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ca59cc67ece1bea9cf0b47d2e189326096d43c10d9fba367e7818bae8b3f081"
    sha256 cellar: :any_skip_relocation, ventura:       "98146922e9dc9e245650ac40e7ab79cb044f0d367112eba6d3ab4da13905a7a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f7b8a6d5d86032d044cd934743952fb34c0d15211362addc73e09f4d059fceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e48893380a9c0eadc0076a73020fdaafd84bed9c1315d48bc3438d5889e61095"
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
