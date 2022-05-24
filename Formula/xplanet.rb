class Xplanet < Formula
  desc "Create HQ wallpapers of planet Earth"
  homepage "https://xplanet.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xplanet/xplanet/1.3.1/xplanet-1.3.1.tar.gz"
  sha256 "4380d570a8bf27b81fb629c97a636c1673407f4ac4989ce931720078a90aece7"
  license "GPL-2.0-or-later"
  revision 4

  bottle do
    sha256 monterey:     "82befd651c2e7a35aff92bf1f72cc78bbc024f6e320d03259a2e08545f13d13c"
    sha256 big_sur:      "48c24de21612e3a5cb19747db269ec15dc1a85a4e49c6e0c0c87b0bdf5b15d90"
    sha256 catalina:     "c8e659713aaa70e8fc00d48e15cf997648759afa7b6ff8e0979212348fd6cc8f"
    sha256 mojave:       "9912c643de81e812f69e639e1fe1ee3ee45900d85ce23409adb0a394305b970b"
    sha256 high_sierra:  "aec227666c4e6216b061e979c5aabd1343c9c6433e8f85868f0f12eff3c01b62"
    sha256 x86_64_linux: "1c2c1983311884d2e1f44f12abc016b17cfff7409b0c562f507d738972d0e85a"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  # patches bug in 1.3.1 with flag -num_times=2 (1.3.2 will contain fix, when released)
  # https://sourceforge.net/p/xplanet/code/208/tree/trunk/src/libdisplay/DisplayOutput.cpp?diff=5056482efd48f8457fc7910a:207
  patch :p2 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f952f1d/xplanet/xplanet-1.3.1-ntimes.patch"
    sha256 "3f95ba8d5886703afffdd61ac2a0cd147f8d659650e291979f26130d81b18433"
  end

  # Fix compilation with giflib 5
  # https://xplanet.sourceforge.io/FUDforum2/index.php?t=msg&th=592
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6b8519a9391b96477c38e1b1c865892f7bf093ca/xplanet/xplanet-1.3.1-giflib5.patch"
    sha256 "0a88a9c984462659da37db58d003da18a4c21c0f4cd8c5c52f5da2b118576d6e"
  end

  def install
    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--without-cspice",
      "--without-cygwin",
      "--with-gif",
      "--with-jpeg",
      "--with-libtiff",
      "--without-pango",
      "--without-pnm",
      "--without-x",
      "--without-xscreensaver",
    ]
    args << "--with-aqua" if OS.mac?
    system "./configure", *args

    system "make", "install"
  end

  # Test all the supported image formats, jpg, png, gif and tiff, as well as the -num_times 2 patch
  test do
    system "#{bin}/xplanet", "-target", "earth", "-output", "#{testpath}/test.jpg",
                             "-radius", "30", "-num_times", "2", "-random", "-wait", "1"
    system "#{bin}/xplanet", "-target", "earth", "--transpng", "#{testpath}/test.png",
                             "-radius", "30", "-num_times", "2", "-random", "-wait", "1"
    system "#{bin}/xplanet", "-target", "earth", "--output", "#{testpath}/test.gif",
                             "-radius", "30", "-num_times", "2", "-random", "-wait", "1"
    system "#{bin}/xplanet", "-target", "earth", "--output", "#{testpath}/test.tiff",
                             "-radius", "30", "-num_times", "2", "-random", "-wait", "1"
  end
end
