class So < Formula
  desc "Terminal interface for StackOverflow"
  homepage "https://github.com/samtay/so"
  url "https://github.com/samtay/so/archive/v0.4.1.tar.gz"
  sha256 "36da89d40f485c1405ee267935a245e8db3ef7e3cfc69f20c787c63c5a3c84be"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "de4cc9bdda9df0383396eae604246abbcd6f3c4ee08b135425b65953ef9965c6" => :catalina
    sha256 "0ab815531c1b56906ae002afcb10cce5d7975c9c25371b783a4a5d5c355c9335" => :mojave
    sha256 "e55d72cfc0581ac7e22568511f95bdfb10a6253d68fa2bff0675f278a13db4f4" => :high_sierra
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
