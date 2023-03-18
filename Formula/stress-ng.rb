class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.15.06.tar.gz"
  sha256 "c38cefcf0a83f6c65aed7c36e57a9a1ee8373418ef71cf089a75b0661dcd4623"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a915857f7c3b33b42ad6294a18fad5034e01dee4bb65b02b47565f2f90cffb4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a68db7c3bbe1373869b649609532c6aeedd3a1c9312b9ef11979ee62502de37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a103398dca5bb6de74eb9baa0bf31976d2150dcc22837d685ae7205fccbd8d7"
    sha256 cellar: :any_skip_relocation, ventura:        "8429f9cb520519e836663848588ec88298ad46c424105375fd58a3807f3b5c7b"
    sha256 cellar: :any_skip_relocation, monterey:       "41dbea067e19c376a50241f27cac05096b48bfdd05fd5958818919f7f67946cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "69d06a8bd08bf4863fe61abcb2fe99d356c9b42003d92e54a569463cc52284d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "586478bf6c3378dcf81c1148fc1dff1e993cc38863bcc84823d872fa1cd60818"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
