class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "https://ftp.gnu.org/gnu/xorriso/xorriso-1.5.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/xorriso/xorriso-1.5.4.tar.gz"
  sha256 "3ac155f0ca53e8dbeefacc7f32205a98f4f27d2d348de39ee0183ba8a4c9e392"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2ed8bc669d65635fc5d3c0f91eab9ca3d34dff6319844bbdb5332e4c2923dd64" => :big_sur
    sha256 "95c4fa76a9120ce3a9eabb732442c6854077ab83ef4c6fc8698a322fcaefa5e5" => :arm64_big_sur
    sha256 "ba9353c38b3109630b543faf56f9f8431ec225db32e5f446495528879fcdc361" => :catalina
    sha256 "e85cf1dfeb93797ef41680738cbde8fdf02aecb8040681742c2c89c82659c871" => :mojave
    sha256 "341b85b60e1762c6ffca661940ce5e1958b1f2aab89f49da0865466ad1badc5a" => :high_sierra
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    # `make install` has to be deparallelized due to the following error:
    #   mkdir: /usr/local/Cellar/xorriso/1.4.2/bin: File exists
    #   make[1]: *** [install-binPROGRAMS] Error 1
    # Reported 14 Jun 2016: https://lists.gnu.org/archive/html/bug-xorriso/2016-06/msg00003.html
    ENV.deparallelize { system "make", "install" }
  end

  test do
    system bin/"xorriso", "--help"
  end
end
