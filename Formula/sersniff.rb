class Sersniff < Formula
  desc "Program to tunnel/sniff between 2 serial ports"
  homepage "https://www.earth.li/projectpurple/progs/sersniff.html"
  url "https://www.earth.li/projectpurple/files/sersniff-0.0.5.tar.gz"
  sha256 "8aa93f3b81030bcc6ff3935a48c1fd58baab8f964b1d5e24f0aaecbd78347209"
  license "GPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6f2692fa29a421c6b719dd5c51d71c9f5d5d3e4cbf058727ca652ba89ae4d74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2af9b8fe84f5c4f7e25d4f52eb158c998ae99d680710bd6fe893d80819f3dd16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19301da40a05c325351a5515259fb4f08c4418eeb0609080434d9cf5dead776a"
    sha256 cellar: :any_skip_relocation, ventura:        "a6cb50955a0fa7ff6976ceccc2337d6e3c9695b9790462abab79b7870224c3f5"
    sha256 cellar: :any_skip_relocation, monterey:       "2015d27fc77825cf49802b4c72b5a217cdbecbe923f2a5dd916d305297360cac"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b4c1c881a01c7bbcd7a21883723d91328ed82697d0e944e01f566c43afeafd5"
    sha256 cellar: :any_skip_relocation, catalina:       "96f5d56b1d6c9acb8b465a1912fbd03f6837e0ffabf643200b40528ec7984358"
    sha256 cellar: :any_skip_relocation, mojave:         "89c553505287f0cbd3ef2d46c6b04eb328d0748db6e60511b25d24cefcab83ce"
    sha256 cellar: :any_skip_relocation, high_sierra:    "eb3cf737a135049c3f7b8bacf4d71670dfc755a1b266f41f0865fb8983a53d55"
    sha256 cellar: :any_skip_relocation, sierra:         "077112b0300e14f956fbe45ff650cf973e04c355707a3add63b8efc7fc047737"
    sha256 cellar: :any_skip_relocation, el_capitan:     "abde8af644fecfa883abf597486fd269b379001ae29161fbd21777d0506edc86"
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
