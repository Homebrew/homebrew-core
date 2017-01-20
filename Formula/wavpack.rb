class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "http://www.wavpack.com/"
  url "http://www.wavpack.com/wavpack-5.1.0.tar.bz2"
  sha256 "1939627d5358d1da62bc6158d63f7ed12905552f3a799c799ee90296a7612944"

  bottle do
    cellar :any
    sha256 "3baff92fc3406d91d31bdd03aea25060101672153994959b2d3897c411301afa" => :sierra
    sha256 "7683eb2203214d8ab41ead4cd7bbe47b522a2dc8ac7f861d41b79143c82361c0" => :el_capitan
    sha256 "8edf6d12295eb29d88e38d5c9618504508db63367ceea9f16a7e3aa4d9cfeebc" => :yosemite
  end

  head do
    url "https://github.com/dbry/WavPack.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    args = %W[--prefix=#{prefix} --disable-dependency-tracking]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system bin/"wavpack", test_fixtures("test.wav"), "-o", testpath/"test.wv"
    File.exist? "test.wv"
  end
end
