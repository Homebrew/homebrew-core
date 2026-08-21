class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "a988315322f8c70a95255b1ddd084e48f13fbfa87ff50854e4446a7ae8ed37c9"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "45533d864d4d3fada7cb180cf27eeb60e1510072b74eefe822359cf4a355b391"
    sha256 cellar: :any, arm64_sequoia: "62ef4ac1f18363028e7017684992ac23f2334a11f298fd4458d2e6bd9831f00a"
    sha256 cellar: :any, arm64_sonoma:  "39c330cd47c12d85af794033f046c4ee715050b5d8502112fa4daad2500995fe"
    sha256 cellar: :any, sonoma:        "b24c37efaa24d294f0c192f31c6e375ea530d99ef503f640d21ce017a4210686"
    sha256 cellar: :any, arm64_linux:   "abc1a85164596e1b9c9fca934dbf44f18b8ee86bb8363a67dfb7e981fd5c93e0"
    sha256 cellar: :any, x86_64_linux:  "ae5410739c6d37fe9aff8e9964e9857e5be3167c1c845ba25abb5e8ade6fdbcc"
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
