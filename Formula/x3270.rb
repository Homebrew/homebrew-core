class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.02/suite3270-4.2ga9-src.tgz"
  sha256 "5f0c0c3783f50a3e9858675983a521fb56039bf36243229715ffae8e200d2806"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "394d9e6f1f4bbd30481e5e22b5c4712d24135ca5ff2df4fbf46b76e05b868636"
    sha256 arm64_monterey: "c35243d8b763ce6591d8bf2168c75c177ebd0d0795c9ec3bee2bb1ef1b0620d7"
    sha256 arm64_big_sur:  "2f32ed029223aebc05df44445f80255e02acf8bcd2084b94b4396190224b9496"
    sha256 ventura:        "4a1b6d0a16fdf5de63453631fff443e5c33869dbd8ddc5c4b2712e062ae95b0c"
    sha256 monterey:       "e23ce68213ca0d2e18535e56eb5701d74969abf3c69a6d485c36b87afd791ee7"
    sha256 big_sur:        "11bb43fe01f0d3f08b5567e62a963fc68ad7e1519be5b88f6cbfa139d26ed77e"
    sha256 x86_64_linux:   "fefd64e18d19454c3083ce77e2ea9d9d515914c3121f814c3ac6abfd341412fd"
  end

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
