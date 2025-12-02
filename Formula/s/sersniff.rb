class Sersniff < Formula
  desc "Program to tunnel/sniff between 2 serial ports"
  homepage "https://www.earth.li/projectpurple/progs/sersniff.html"
  url "https://www.earth.li/projectpurple/files/sersniff-0.0.5.tar.gz"
  sha256 "8aa93f3b81030bcc6ff3935a48c1fd58baab8f964b1d5e24f0aaecbd78347209"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?sersniff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a497adbb93a2bfefadc8e54b0d25dca7829014ae9dc1bab68ba32d6308fb8dc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0b6380a7ceb537b939e10a5cd9a128e95dd0eaf249c80889ba0e5b81173258dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea7c22e807346b57a650e6f9c69caffd3f3e228b5af9426df80049ad85082c64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6f2692fa29a421c6b719dd5c51d71c9f5d5d3e4cbf058727ca652ba89ae4d74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2af9b8fe84f5c4f7e25d4f52eb158c998ae99d680710bd6fe893d80819f3dd16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19301da40a05c325351a5515259fb4f08c4418eeb0609080434d9cf5dead776a"
    sha256 cellar: :any_skip_relocation, sonoma:         "756ba4cb630261cad8a7da71c63e826d586b1d73b35dfbf19564d634d7a8a791"
    sha256 cellar: :any_skip_relocation, ventura:        "a6cb50955a0fa7ff6976ceccc2337d6e3c9695b9790462abab79b7870224c3f5"
    sha256 cellar: :any_skip_relocation, monterey:       "2015d27fc77825cf49802b4c72b5a217cdbecbe923f2a5dd916d305297360cac"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b4c1c881a01c7bbcd7a21883723d91328ed82697d0e944e01f566c43afeafd5"
    sha256 cellar: :any_skip_relocation, catalina:       "96f5d56b1d6c9acb8b465a1912fbd03f6837e0ffabf643200b40528ec7984358"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a6cc2f34cc92c711ec8c23b221fa6653e049d603b5f62396cc7045b6f193046e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f846011946336bff588b904e16d8c0857b4b196467ca98604cd001c0c361f34c"
  end

  def install
    system "make"
    bin.install "sersniff"
    man8.install "sersniff.8"
  end

  test do
    assert_match(/sersniff v#{version}/,
                 shell_output("#{bin}/sersniff -h 2>&1", 1))
  end
end
