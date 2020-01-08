class Wmctrl < Formula
  desc "UNIX/Linux command-line tool to interact with an EWMH/NetWM"
  homepage "https://sites.google.com/site/tstyblo/wmctrl"
  url "https://sites.google.com/site/tstyblo/wmctrl/wmctrl-1.07.tar.gz"
  sha256 "d78a1efdb62f18674298ad039c5cbdb1edb6e8e149bb3a8e3a01a4750aa3cca9"
  revision 1

  bottle do
    cellar :any
    sha256 "7fffdc3399b2af15b638dfb642e44e0c148df088828f307c1f9440e38049cd5a" => :catalina
    sha256 "2223922cda28d81580d85d01fa697284102d10226df76d57660bd92093fd46c5" => :mojave
    sha256 "59b55236fd42a64f6ccc8587a5580a25afd330a137b62e7258568042e8b1b525" => :high_sierra
    sha256 "cbdb379f9b1264847f74c0ea01e0a5412645b442d3c069708bfbe209b845b873" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on :x11

  # Fix for 64-bit arch. See:
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=362068
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/wmctrl/1.07.patch"
    sha256 "8599f75e07cc45ed45384481117b0e0fa6932d1fce1cf2932bf7a7cf884979ee"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/wmctrl", "--version"
  end
end
