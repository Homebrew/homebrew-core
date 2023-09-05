class So < Formula
  desc "Terminal interface for StackOverflow"
  homepage "https://github.com/samtay/so"
  url "https://github.com/samtay/so/archive/v0.4.9.tar.gz"
  sha256 "b6327268acf3e9652acebea49c1dfa5d855cf25db6c7b380f1a0a85737464a4a"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06d9d49939df633028f759557787975e717b12e496a3d20da54afd375c3967e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b94994807aa75017eaec7f76ea78cc80c3fbcf2c0a65dfba043a3ca2d62b663"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8afac14e917fad150dd5b06f28b96c14d49ca5c7b2894e7488f9dedbfcbfb9e8"
    sha256 cellar: :any_skip_relocation, ventura:        "f845494b286ee5b6301c5a347ca3df396cb071797cdf9fbfadb47d9309acddf1"
    sha256 cellar: :any_skip_relocation, monterey:       "0feba955d0c7ffc8ce409df43b27831f263f9b1d85c4496ab4c4d31116e43b55"
    sha256 cellar: :any_skip_relocation, big_sur:        "982259bab8f867dd1387facce0ee77c60610f478214f0579ccc46db24c87cd62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c36a6333d2954cb49b323520e4e337b81d975c440c440aae10eb4f315cb210fd"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
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
