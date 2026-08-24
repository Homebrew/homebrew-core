class Vcdimager < Formula
  desc "(Super) video CD authoring solution"
  homepage "https://www.gnu.org/software/vcdimager/"
  url "https://ftpmirror.gnu.org/gnu/vcdimager/vcdimager-2.0.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/vcdimager/vcdimager-2.0.1.tar.gz"
  sha256 "67515fefb9829d054beae40f3e840309be60cda7d68753cafdd526727758f67a"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e45840390e18c75e9c7c069cf3737c1497438dbdae5c439647601b3cc806c10a"
    sha256 cellar: :any, arm64_sequoia: "1c3d9b650ca9edca6afeff27b21715cfecf1b1028e7651d2a6d3c8d6cd88a959"
    sha256 cellar: :any, arm64_sonoma:  "807bb89a0112255bab85ae28229ff4c7bcc2b4e7ba09923465985a5112328825"
    sha256 cellar: :any, sonoma:        "9cf2efa8c804d2c6d5efb8019e0a8f158e9ca67e8907e45b6a8a637af9ec670b"
    sha256 cellar: :any, arm64_linux:   "fafae5dc8ff415c19fe027287624504888d256bb180ae72f39ba6abfbae264a0"
    sha256 cellar: :any, x86_64_linux:  "2f86117bf7ab5432a44e538bbdd153f07844fbb9110fb701cbe2e9e19084dad5"
  end

  depends_on "pkgconf" => :build
  depends_on "libcdio"
  depends_on "popt"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-big_sur.diff"
    type :unofficial
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"vcdimager", "--help"
  end
end
