class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "https://www.wavpack.com/"
  url "https://www.wavpack.com/wavpack-5.4.0.tar.bz2"
  sha256 "0716a6dcf9a72d61005e1b09bbbd61aaf49837cb4e4a351992a6daed16cac034"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "711535e6329af607e974ee9e3e957fd82b056af39e95a78226bd9e8f9a0025dd" => :big_sur
    sha256 "3e51f2f593fffc58cd550236d6a9711900841d388d6ac7833c09f272270d5156" => :arm64_big_sur
    sha256 "29360357a18df2827e8acb41fdd874495b62f431deb230c96b8d5dcca5f6d316" => :catalina
    sha256 "89815dc5f1b4af0d647d2b1d3ad484ddce39208958bb315793240aa7be0c4565" => :mojave
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
