class Threatdeck < Formula
  desc "TUI threat intelligence monitoring and alerting platform"
  homepage "https://threatdeck.io/"
  url "https://github.com/gripebomb/ThreatDeck/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "eca039c274ffc0c1f121d2f5f22f68d070011b2754819aa7a6ed58e50c9b5b7e"
  license "MIT"
  head "https://github.com/gripebomb/ThreatDeck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc7d8bdc2065418c881e0feef2ee4ca4059795c6a981ec793237fe079496431b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a52fdecde90e732c37ad438637cec658b92af0321aea32aa49b4ea1d5f46853"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46f272598ba7d13df7a7735aa2b1536ff304c3ef0e938295c52b0fd400beaa52"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa7dc27ea1ef901b96671c330ca85cefde44ede850bef4962a85f4639705e76e"
    sha256 cellar: :any,                 arm64_linux:   "0258d2039b8ee7cfc999598f47884fd1ec06f4aaf3bac87c81cd847b01fe1c86"
    sha256 cellar: :any,                 x86_64_linux:  "1c62325d1692ca8c10d7858e7120386be696046a381816fef0f93bc6b9561925"
  end

  depends_on "rust" => :build

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

    screenlog = (testpath/"screenlog.ansi").read
    assert_match "Alert retention", screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
