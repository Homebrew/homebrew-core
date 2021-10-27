class So < Formula
  desc "Terminal interface for StackOverflow"
  homepage "https://github.com/samtay/so"
  url "https://github.com/samtay/so/archive/v0.4.5.tar.gz"
  sha256 "e036d2690c1b35bdc092527f6f0d2ff46616350c3eb360badf58fb93ea730b45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b5432cbe9c768d66cd14d39ebc5f60c2bb5ef79bde72a7863f37698d822ec8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "610b5f0641c444faa1b1593ccb7555f2cf13d60753fec19fe12f73b32a1f7502"
    sha256 cellar: :any_skip_relocation, monterey:       "8acf900ff9c9eed60d163bd0b3349d19d831e6ea35e0d8405f238e433dd76b8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fd6e485c657d6fefe2309ef533cd9c199f1633d1a499d5bc9abcaabd6a831d7"
    sha256 cellar: :any_skip_relocation, catalina:       "e6e42abbaeacfec3ae573d3851b3d223e9cc258b8b7da6f044c57ac9b4881299"
    sha256 cellar: :any_skip_relocation, mojave:         "dcec7fc7c8093201de8c9b7e71d2b326198e6ab7a1d7df7d8fb57638b051ab5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8aa3bf1298fc5707ab57ffa6e44c9e98c5c8a75c83baabfad77424a76e28324"
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
    assert_match ":wq", File.read("output")
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
