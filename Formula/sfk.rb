class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.8.2/sfk-1.9.8.tar.gz"
  version "1.9.8.2"
  sha256 "051e6b81d9da348f19de906b6696882978d8b2c360b01d5447c5d4664aefe40c"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(%r{url.*?swissfileknife/v?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18d9803316f2401a1968b612041a7e82feb281cfd7b3ed9623ea217f64ec4453"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ee72add140bb65a9a321ecc7995f9569faf1a781a414e6c29150160e714e577"
    sha256 cellar: :any_skip_relocation, monterey:       "d7e73e0e79d13aec762f1305d7f37ff2f6e0cf9a7632bb563ddbb8e8a167a240"
    sha256 cellar: :any_skip_relocation, big_sur:        "a02c2a0af4647ecc3ac769d65bf7f3b380986fc6ce86a0abf443b8b1da6084f5"
    sha256 cellar: :any_skip_relocation, catalina:       "a48c5b3fca272552ace60bc3a8a10636cb54da3c79f9fbf98314504582ba9546"
    sha256 cellar: :any_skip_relocation, mojave:         "4070b917ef0c60cee55d29f6c563069e2eb23793e3024f008e1a76c15f476bb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbf68a56c2cfcc7885613d983bf110659c221a547e5102c5779436bd0130870f"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
