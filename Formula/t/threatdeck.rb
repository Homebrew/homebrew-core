class Threatdeck < Formula
  desc "TUI threat intelligence monitoring and alerting platform"
  homepage "https://threatdeck.io/"
  url "https://github.com/gripebomb/ThreatDeck/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "7fafb2a934a76a3c19b839149d12f12fc5ae9becfd353306f40e3c9234d1f653"
  license "MIT"
  head "https://github.com/gripebomb/ThreatDeck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1aa44bd0bbb9f8c9bb3d700560c14e146d4c049de878aeb8199c9fa6bf41ebab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "338a548ca952c2bca1a14b535ecd0277479f7e8dc7ec50ffee93f8f5af8f7d5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e181e7e369c964b462da325c17310e46064c63fc89d0a04b7f6e6f138ebd168"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a451b8d1f1f7318fa7044019798035f97d73203bdcf3d14b311d4ccc00090a8"
    sha256 cellar: :any,                 arm64_linux:   "218ee543e23f78ed2cb7f2ed31f2d0c99877b94c409b2165950202de6187f421"
    sha256 cellar: :any,                 x86_64_linux:  "30311f7dc707c911e6380c2f060ebe9b959594b333d5efeef5c5ebc98622d675"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input, _, wait_thr = Open3.popen2 "script -q screenlog.ansi"
    input.puts "stty rows 80 cols 130"
    input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ThreatDeck"
    sleep 2
    # select settings tab
    input.puts "0"
    sleep 2
    input.puts "q"
    sleep 2
    input.close

    # The captured TUI screen contains invalid UTF-8 bytes, which would make
    # assert_match raise; scrub them before matching.
    screenlog = (testpath/"screenlog.ansi").read.scrub
    assert_match "Alert retention", screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
