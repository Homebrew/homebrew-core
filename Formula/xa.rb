class Xa < Formula
  desc "6502 cross assembler"
  homepage "https://www.floodgap.com/retrotech/xa/"
  url "https://www.floodgap.com/retrotech/xa/dists/xa-2.3.11.tar.gz"
  sha256 "32f2164c99e305218e992970856dd8e2309b5cb6ac4758d7b2afe3bfebc9012d"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href\s*?=.*?xa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f0ed026e20af3244375937a7bfb33f0e52bc22b5df4ba6f60b5a118ed61f990"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e17d657560922230517dfecf5d6600f0aae85c17bb86108a9c6c935be3a1bde7"
    sha256 cellar: :any_skip_relocation, monterey:       "472a125138a88e1b91f803cf38a3a2c0af5e86ac36bb541495fa6cbd9f425088"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f45f1bf0cd1d43ff2135c305ec836301dcc6d58d1ebc0f7fdbe9d9b9fb747a7"
    sha256 cellar: :any_skip_relocation, catalina:       "82ac5a005305bb5fd7ff181e2f9aae95ad5f865574ed4cb8f936948cce406a72"
    sha256 cellar: :any_skip_relocation, mojave:         "6dfd866eea2c29d98aabbe4b9a0821ad9b808b0d2b7754b3400f5bb4f4cb4184"
    sha256 cellar: :any_skip_relocation, high_sierra:    "40334865dd2af12409a5c52ed9a8d3a5bd6b781da28375509e2481bd885c87e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e2307408fb7c597ccda244fb3b8ade5b5ba1388acaddca5e8607c9400f08b36"
  end

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "DESTDIR=#{prefix}",
                   "install"
  end

  test do
    (testpath/"foo.a").write "jsr $ffd2\n"

    system "#{bin}/xa", "foo.a"
    code = File.open("a.o65", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x20, 0xd2, 0xff], code
  end
end
