class So < Formula
  desc "Terminal interface for StackOverflow"
  homepage "https://github.com/samtay/so"
  url "https://github.com/samtay/so/archive/v0.4.9.tar.gz"
  sha256 "b6327268acf3e9652acebea49c1dfa5d855cf25db6c7b380f1a0a85737464a4a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "940ed2042c9c04ee89ea61a0f580eabecd2cfa4c5eea7f63fca11786abcbbb61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a48cd7ac2ba8b3289db6920bb611eb051e3711287569331292ab9c4f7652bbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47389e3710448b5bcccfd92eaa3624c347c86e911baf70fb4a5d41580289f696"
    sha256 cellar: :any_skip_relocation, monterey:       "abd12b88855ecd1f853a8fb926ef0d1ecc20541a5b4e05f7ef03ef5759f80598"
    sha256 cellar: :any_skip_relocation, big_sur:        "893ed4998287a50c96a0332700f4c98ec56817c7e6f00423fdf5cbac9ffd3453"
    sha256 cellar: :any_skip_relocation, catalina:       "72337e5a8cf8a9b8816b9a236f17ee36ca0132c99160bfe0e472351131cd64cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a30a6cb07820c5a35331564e09cd7530baa7f976d5bc8648ca9f8aeb1e803fa"
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
