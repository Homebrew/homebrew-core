class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "f5e232d6ae4a683eb2010394cac8aea8fffd361b22e498450252cb9e502b859e"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b5abcd22dac80786d71e083a1bcc5143b1658706c78c54231eae150f4b1567ac"
    sha256 cellar: :any, arm64_sequoia: "ae56a9227a90a1f3242a8d4c8903d3848e1f5108869555f5dd957c43cd29e598"
    sha256 cellar: :any, arm64_sonoma:  "d9a7f9fa563ecdb0c610b2f3a3be792c8b9b1e7c4a20c139865f82f09290901a"
    sha256 cellar: :any, sonoma:        "2de6f9f3b908ed5a9c37e710c9a6292b0d7d7758e194370019698d0f0d24e028"
    sha256 cellar: :any, arm64_linux:   "82be5194ad4ddd23d337fed33f758f4d906565b29e3b6946248dada2dbc9ee03"
    sha256 cellar: :any, x86_64_linux:  "834c140c7ee149a66588c6628150fa9da7391de65ec3d4d76ffe42d2e3f2d209"
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
