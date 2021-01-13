class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "https://www.wavpack.com/"
  url "https://www.wavpack.com/wavpack-5.4.0.tar.bz2"
  sha256 "0716a6dcf9a72d61005e1b09bbbd61aaf49837cb4e4a351992a6daed16cac034"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    rebuild 1
    sha256 "78570562d7429a48decbdd52fad54a20f8c768d8a529c314e424a60ede55ecb9" => :big_sur
    sha256 "53e06631a0fd39762ad7d858b059df1a45af5244f1d1951832ae6c7faabba3d9" => :arm64_big_sur
    sha256 "faef125fe8557e79bc97e1ded99e0050997fff0aba8cf0628771b686d5251244" => :catalina
    sha256 "f8237f75aa50b6e8bd97bb4e3729a477ac569936d63d67a0df6e665ec4069a59" => :mojave
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
