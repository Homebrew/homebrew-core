class So < Formula
  desc "Terminal interface for StackOverflow"
  homepage "https://github.com/samtay/so"
  url "https://github.com/samtay/so/archive/v0.4.2.tar.gz"
  sha256 "402d3a07283375d92892802544481a417f9d017b5e80733183ccbce3a810ef84"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "025dcb2e1d0f2d7b32deca9e1968ef7ebc5411ecb3e242314187b812c687f278" => :catalina
    sha256 "e7e7c05ed831ebb7515ce16315bd26e744060f4bc57e1a7cf343214d9b917248" => :mojave
    sha256 "d8dd79026d6cd1074d5acefc7c6642b9dcfa293b0c8d42c3e21962aa68a257dc" => :high_sierra
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
