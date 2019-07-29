class Srmio < Formula
  desc "C library to access the PowerControl of a SRM bike power meter"
  homepage "http://www.zuto.de/project/srmio/"
  url "http://www.zuto.de/project/files/srmio/srmio-0.1.1~git1.tar.gz"
  version "0.1.1~git1"
  sha256 "00b3772202034aaada94f1f1c79a1072fac1f69d10ef0afcb751cce74e5ccd31"

  bottle do
    cellar :any
    sha256 "68a96377224e3eaaae6bf5b2fd984d7cdbbf62a094a52671c2e260509577e8c9" => :mojave
    sha256 "5d46a88acdd891c6ab67c32215a80078946495949891c1181cc00abdda972800" => :high_sierra
    sha256 "9ca9c4a2d17c7f431b1ad9899ae97ea22ec44e24a9c0c60220638c0f31f9b2c4" => :sierra
    sha256 "9e45cba0daaa89683552f1feb19cd49c42d27a311113ecb204ae8c2e48231f3f" => :el_capitan
    sha256 "e71a6c2fac5115cae2fe1a8b7eea9fb5800b96f908adf357a667b5df70bd7089" => :yosemite
    sha256 "d0c35e531e9defc37adc487e00a18ce46b59181bbdf74d46cbc9f5618153d5e4" => :mavericks
  end

  head do
    url "https://github.com/rclasen/srmio.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      chmod 0755, "genautomake.sh"
      system "./genautomake.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/srmcmd", "--version"
  end
end
