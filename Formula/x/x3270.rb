class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.02/suite3270-4.2ga10-src.tgz"
  sha256 "db513225f074144a5a0221d57ede37cca1468c2c2d158ea09981f50012ebdbe7"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0bfcdb72385c5efde177651a5d7b66d7642a108cca7db7cbaa011d23aebb3083"
    sha256 arm64_monterey: "6f8cf10bcf88cc87e7dd06d75df430a9f01201249e9cf3e93d08064ec51ae743"
    sha256 arm64_big_sur:  "ad73e66d09987ec0217e17ff2412271144087862ad9990f682fd6e9fe9f3018c"
    sha256 ventura:        "82ae1840e2daed3ea252f8f6a033a8a42128a5e61f29820ef2996c59e091c1a3"
    sha256 monterey:       "1cce8fbb1e74c9f1810d951e04e8e47ebadefaeb6c60c0cb5f9c1af3238b7589"
    sha256 big_sur:        "6600aefb5c8e3fe7e3d2f20fe8cb8f60f13180caa7ad2f17eaf1c82fea3eec72"
    sha256 x86_64_linux:   "7f8b9436bf8e7d1c9b7bdf5f488a237effd427a4cb61e0198a9ccd6dd7b27b00"
  end

  depends_on "readline"

  uses_from_macos "tcl-tk"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["tcl-tk"].opt_include}/tcl-tk" unless OS.mac?

    args = %w[
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]
    system "./configure", *std_configure_args, *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
