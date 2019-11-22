class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "http://www.wavpack.com/"
  url "http://www.wavpack.com/wavpack-5.1.0.tar.bz2"
  sha256 "1939627d5358d1da62bc6158d63f7ed12905552f3a799c799ee90296a7612944"

  bottle do
    cellar :any
    sha256 "3d52fb37bf050db331368c4716b35381f981a5a85e3b840b5c44993c561eb146" => :catalina
    sha256 "d3e4d68fb79133858eda5a35db5e3d92cbc40fc96d2ee414b92c9502792e641d" => :mojave
    sha256 "3c474a8b2b524f596888089a374aa733c09615e4a861a11b7317204ef42c8c25" => :high_sierra
    sha256 "caaf7a9f778270e2f445c4a4f864afbdbc5c410531866c06a5bfe9d0b10dbc36" => :sierra
    sha256 "5ad0e936fa7f53926838964c434e34c303bb540f676fb42b03d37845ace86940" => :el_capitan
    sha256 "14d36c9f2f704d8d1181f63ad965690a4594444394ce42d2cfaf63cbfc981051" => :yosemite
  end

  head do
    url "https://github.com/dbry/WavPack.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
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
    assert_predicate testpath/"test.wv", :exist?
  end
end
