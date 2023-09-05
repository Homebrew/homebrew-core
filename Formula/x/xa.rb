class Xa < Formula
  desc "6502 cross assembler"
  homepage "https://www.floodgap.com/retrotech/xa/"
  url "https://www.floodgap.com/retrotech/xa/dists/xa-2.3.14.tar.gz"
  sha256 "1b9bbabddbd8d3b9410b852e50a128eea41e681339e6f76c3e8076fa5420f02e"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href\s*?=.*?xa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "172d4111c918fa05acf0602d2319fc82b132caa45ac28c5efb0e93b82eb31095"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e36e9f9ee137f4a114d18fe00824a3ee99a79402ab8ffa5fa163e1ce727b66fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de1f333683f9ee7da2f97a64b2d81f7e2dd1d682c7a344226d029a9fff5b2ad6"
    sha256 cellar: :any_skip_relocation, ventura:        "a7a11bcb7e77bf152fa9e7efadccb7d1f43b7deba30b230a7bea882ade915a59"
    sha256 cellar: :any_skip_relocation, monterey:       "dde1b4784048684759394096b4ddf2fd26eeb78824bb0a18212b8ea31335062e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0868d331255bc58b921606c29f0f59d484e4331cd407645de6894fc67b4f3557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43df54eda0dc37af75135b339767dc19bad10aab69364abc149e32551dc031c3"
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
