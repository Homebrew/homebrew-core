class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.03/suite3270-4.3ga5-src.tgz"
  sha256 "1ed1bfeaa6bb67618e2e13b05fabcbb78a1d9c488bb8239d860f402bc737d308"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "cfda9ee75e5c8857d129644caafa59957b7fb7efde181369acdadf694f9253f1"
    sha256 arm64_ventura:  "1fc246d545d7114f9dfb10167279cfc6b6c839c0e2262b9b92042e02beaf9870"
    sha256 arm64_monterey: "1131cddc69df22cc8816a73cf37acdcbf57f088d82bc2b0dc8f1c9904cf3d204"
    sha256 sonoma:         "48338dadde897f398e0eba6c3d761a9715915cb4920169562e9c5e5675a93ae6"
    sha256 ventura:        "67a19c1841ebe18c1175f8ed283112c3ae078f68c7824337215bc3bf789395dc"
    sha256 monterey:       "bd56f10727a575ed5663681d2254dc508b2f6d0d3c60062882995273c192ff93"
    sha256 x86_64_linux:   "e632651b7dd2643aa8c13a3ed3a79a6ec6d6338e33ab1b70e573eb78dc749dc9"
  end

  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "tcl-tk"

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
