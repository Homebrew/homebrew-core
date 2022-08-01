class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "https://www.wavpack.com/"
  url "https://www.wavpack.com/wavpack-5.5.0.tar.bz2"
  sha256 "7a222f96c391138d340793a1b06d517d7a514de85b5915216051b7386f222977"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f7b8b75495e5d9ee17b60243322a52349ce65a89de9c0dd6f9d9d35461d8b0c6"
    sha256 cellar: :any,                 arm64_big_sur:  "e34bfb3ebb2f06c4f7fc22a587400acbbb4853bb106cbe3b679b4512cacc254b"
    sha256 cellar: :any,                 monterey:       "effd5ef1000609272a70f2d84e6a2bf61a200a5b1bc239a7d89eb13d97be6a57"
    sha256 cellar: :any,                 big_sur:        "ab5cb74fc57673c4bbae53a5325d486ab3a4151a00fbfc89f2c06905a00ad345"
    sha256 cellar: :any,                 catalina:       "cce469c6e14c269c49e71f1bc71631bb286728a77af844ce68567b9645cdf01a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58baedd42d91d72acd6fe3f4624e60fb7a24c6fdc0df36f20b6cd5739d557ce3"
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
