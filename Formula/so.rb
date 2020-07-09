class So < Formula
  desc "Terminal interface for StackOverflow"
  homepage "https://github.com/samtay/so"
  url "https://github.com/samtay/so/archive/v0.4.0.tar.gz"
  sha256 "a1f7485ee5028a07a12efcb860367d703015680be2a1001545b9bf3b0f9299a5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2f6017640c81a6cb40364b8ef4e11ca3b688d69413f08652fa44989e3fbf73d" => :catalina
    sha256 "6f4aa633f76cf93b7e69a7ebc10583a3849452a5d647ee3cd58c2f410cdb38ab" => :mojave
    sha256 "6b021d14682f24f76b815d7730c52fa334ed7beedfcd1491ae29474891d29adb" => :high_sierra
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # try a query
    opts = "--search-engine stackexchange --limit 1 --lucky"
    query = "how do I exit Vim"
    env_vars = "LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm"
    input, _, wait_thr = Open3.popen2 "script -q /dev/null"
    input.puts "stty rows 80 cols 130"
    input.puts "env #{env_vars} #{bin}/so #{opts} #{query} 2>&1 > output"
    sleep 3

    # quit
    input.puts "q"
    sleep 2
    input.close

    # make sure it's the correct answer
    assert_match /:wq/, File.read("output")
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
