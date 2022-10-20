class So < Formula
  desc "Terminal interface for StackOverflow"
  homepage "https://github.com/samtay/so"
  url "https://github.com/samtay/so/archive/v0.4.9.tar.gz"
  sha256 "b6327268acf3e9652acebea49c1dfa5d855cf25db6c7b380f1a0a85737464a4a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "968cd5e7b36fc7d677e334cfbf818f8c0a746638ba471d7f27bbcff2c9fa36b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8291d50a5f0410c96b930081d408ff207f2d2a84912211163de32e60db3f35f0"
    sha256 cellar: :any_skip_relocation, monterey:       "e39ac50f777618077ab74fb2e354426102b1edb7d3647d940d35b02a72a65c25"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d7643eef9b647d2fc7651c5a3845909898fbcb186503fc808bee1b2caa32542"
    sha256 cellar: :any_skip_relocation, catalina:       "4478bcbb919e22ef9f83ec0c6f73bc53381ed8a3588beb680f230dde53b832f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af48956239eb8eaca6666f9fa6332fa6b6bbe533b8314b7b69f4a698db274189"
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
