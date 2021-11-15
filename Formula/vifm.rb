class Vifm < Formula
  desc "Ncurses-based file manager with vi-like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.12/vifm-0.12.tar.bz2"
  sha256 "33a9618f32b35b5b8c64483884f9ad09963ca8465b2935def79159028e27b2c0"
  license "GPL-2.0-or-later"
  head "https://github.com/vifm/vifm.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "ced1940f97f1fb72f85f73820b387ab7945aaae43119f426900473fb3db807d8"
    sha256 arm64_big_sur:  "f7534889df9f84b519989685295ea92b25d3405d52c4fd02c234278a6e18b067"
    sha256 monterey:       "8a0095983b35fda58e93461623b9b696fec8084417c8d5b34a27343c11beba4b"
    sha256 big_sur:        "4517c5ebdcb849db63e098333fff9826a4fb04738c1e834ba2b3a01f69689d3c"
    sha256 catalina:       "6a88bdb18fabe25b5e1540e3c1eab8185743f551a1223b2940567a1025ff71ee"
    sha256 mojave:         "8e1586f13e371c4c88d18efb84ad1f91333b3fbdca97c757c8d6fcdde2ace9d6"
    sha256 x86_64_linux:   "4a8a8336e7e28fd307f600f87f5490afc56217c38035fec53dc4096f623d4cc4"
  end

  uses_from_macos "groff" => :build
  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gtk",
                          "--without-libmagic",
                          "--without-X11"
    system "make"
    # Run make check only when not root
    # https://github.com/vifm/vifm/issues/654
    system "make", "check" unless Process.uid.zero?

    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vifm --version")
  end
end
