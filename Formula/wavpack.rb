class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "http://www.wavpack.com/"
  url "http://www.wavpack.com/wavpack-5.3.0.tar.bz2"
  sha256 "b6f00b3a2185a1d2df6cf8d893ec60fd645d2eb90db7428a617fd27c9e8a6a01"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "b5aef19f3358dc95367d4709ce6879ed79b5c9e82ef58091369848ead56bad88" => :big_sur
    sha256 "299242c1b63c8c7fa4119fd2bf4308f8cb0b49ac04f4d5502f64555be2cf06e2" => :catalina
    sha256 "6985e1becaf974e8686208a038ade4eb333b68f0166c26cecf3b69f4a84797f0" => :mojave
    sha256 "e767c61eade23b1624dd4d78ee67817ee2175fd42600680aae731b58a4024d12" => :high_sierra
  end

  head do
    url "https://github.com/dbry/WavPack.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    args = %W[--prefix=#{prefix} --disable-dependency-tracking]

    # ARM assembly not currently supported
    # https://github.com/dbry/WavPack/issues/93
    args << "--disable-asm" if Hardware::CPU.arm?

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
