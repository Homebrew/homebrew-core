class So < Formula
  desc "Terminal interface for StackOverflow"
  homepage "https://github.com/samtay/so"
  url "https://github.com/samtay/so/archive/v0.4.3.tar.gz"
  sha256 "ea2aaacda8073bbfd0b22cbb978c18562fb2a82987f48803cf3d566f58fb37aa"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca136c2cfd84c190a1c2b7269640b14cf4d23de1ee9c343bd9709b47c0d91669" => :big_sur
    sha256 "d6d949c7dc2da7b732f51a339725fa373b6cbcbead37e24f040e37286d6ab302" => :arm64_big_sur
    sha256 "5bf7f63a206b7ab5b64f102d493db409a3fb068a76326aa0eaa68582ea779638" => :catalina
    sha256 "13beb97e318c3655cf2a6ecb537f776c5973a7a944c14c212455a359b419b872" => :mojave
    sha256 "cfc2bf938aacca1db66b6a072dca9cc9f346e21a9ae1a7534d3e1124810e0c2b" => :high_sierra
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
