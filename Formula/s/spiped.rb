class Spiped < Formula
  desc "Secure pipe daemon"
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.6.4.tgz"
  sha256 "424fb4d3769d912b04de43d21cc32748cdfd3121c4f1d26d549992a54678e06a"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?spiped[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e5b2448dfa79e10636ee1eaae63d27f776bb23a1accd2e8aa14e0b9bc948123b"
    sha256 cellar: :any,                 arm64_sequoia: "15d4704b11467e652ab11b95799eee5ecc3a02cb3bc7d9d22b4201af4581b7db"
    sha256 cellar: :any,                 arm64_sonoma:  "7c2bb45d44639701ff4742735b874135d0ff89874a0b5783d437b49da8e07fcb"
    sha256 cellar: :any,                 sonoma:        "95d4d32c9e8218f883a4ca1d8685437d1377fc53b5cfb7f56da914776c6dd32e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0307fc57a2e52689f5fb0e0e30fa54e4bfe40e77e0068cd90cc5256bace74f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0220e6792de7330f0da334dc278cdc7eb48bcb9e8d9e36b6facc8a5746b062b9"
  end

  depends_on "openssl@4"

  def install
    system "make", "BINDIR_DEFAULT=#{bin}", "MAN1DIR=#{man1}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spipe -v 2>&1")
  end
end
