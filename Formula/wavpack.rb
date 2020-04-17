class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "http://www.wavpack.com/"
  url "http://www.wavpack.com/wavpack-5.3.0.tar.bz2"
  sha256 "b6f00b3a2185a1d2df6cf8d893ec60fd645d2eb90db7428a617fd27c9e8a6a01"

  bottle do
    cellar :any
    sha256 "ff3ac4375bca41b6a6a683cfe3ca24e36d50682c64dfb1a6cb75841fbac49613" => :catalina
    sha256 "6c1a4ebbd4173c86d2256366be6b09bf7306e9f063d396e02c5230a73312d14e" => :mojave
    sha256 "4d278399b30ee9b7739f13d0da8c1daef781bdb91d2aebe8c2eea0fa3702f456" => :high_sierra
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
