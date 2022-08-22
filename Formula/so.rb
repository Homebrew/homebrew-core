class So < Formula
  desc "Terminal interface for StackOverflow"
  homepage "https://github.com/samtay/so"
  url "https://github.com/samtay/so/archive/v0.4.8.tar.gz"
  sha256 "11e37927b248824d8f2475b695168889afe0c14f9183cf2f31a9c0395d00dd98"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "062fd0b94a6ac4ce7ef80a0a4aa60ad55fb0d53a23d904b8d771bf33be352069"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78b3130870f391d991c1cb5afdfce6b32238129fba5338b7d5cca1430ec1d746"
    sha256 cellar: :any_skip_relocation, monterey:       "c50048fe2b070fcb875ad03734dcef075db537e1f330d0536dcd39f5afbc8524"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed0a9133c3e7a12c33f5c22d425439139227df0626193c337b01d1ab9fe39a82"
    sha256 cellar: :any_skip_relocation, catalina:       "ce8ee56dd515c49d1e5bb1677888b57724dc674c755d3ec669551403be6d5a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5afedf694a6d90e69dcd7e848343c86f96902829c801be03142e9ff6b054aa54"
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
