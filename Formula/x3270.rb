class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.01/suite3270-4.1ga13-src.tgz"
  sha256 "31b256f018099a613c4abc1836f72d00cd18def9df2486ce0ab01130bf9ca88e"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "17eae1f7bb53abd100e3c0b12aa35fe8286a27026e5cc38a617756f4c6bf6c04"
    sha256 arm64_big_sur:  "dfffc828fb2abea2e254cdc3f00c5ce9dbc6c539fbceb7bf86ef89cf231b3e28"
    sha256 monterey:       "79c3fb4ae749288b70a7f8528d26321a8fef53cb40b98c82cf7c4969ab66ca25"
    sha256 big_sur:        "2cbfb4bf23c1cf7c4f80158e2fcb73c25b75db02de757559987a767b0aeec4d9"
    sha256 catalina:       "f3ee0a641f9a2c7962abaf2cf0c48212db3fb34b25c92297dbd495d3fb4bd316"
    sha256 x86_64_linux:   "3e3162289affd48aef816b823497d33d1695814f6f2c151f0f89264d764dff77"
  end

  depends_on "readline"

  uses_from_macos "tcl-tk"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]
    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
