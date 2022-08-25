class So < Formula
  desc "Terminal interface for StackOverflow"
  homepage "https://github.com/samtay/so"
  url "https://github.com/samtay/so/archive/v0.4.9.tar.gz"
  sha256 "b6327268acf3e9652acebea49c1dfa5d855cf25db6c7b380f1a0a85737464a4a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cc4c3815b04b7a86402292969421981429990222347a975d2bebfff86eca8d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39e0b27188924af863581fcacdc8d9765e857b65aa4fa30c6cce72e281363b73"
    sha256 cellar: :any_skip_relocation, monterey:       "1e6abde86dc8d64cf74de91ebf02b39e957fa3abdfbae55b496daee382ad16cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "c78e2c76d4bc0680ba6ea67352af90a723a350a0236bd9d92f5c8c214b4a9eed"
    sha256 cellar: :any_skip_relocation, catalina:       "b12e033f50cdb083290b54af01cb89682e168ba81e3086a67b1ed2db25789223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "445ec6712fb872c42c952e038624af03e3d9710853aec8915fddf0296bab9a03"
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
