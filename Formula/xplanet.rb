class Xplanet < Formula
  desc "Create HQ wallpapers of planet Earth"
  homepage "https://xplanet.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xplanet/xplanet/1.3.1/xplanet-1.3.1.tar.gz"
  sha256 "4380d570a8bf27b81fb629c97a636c1673407f4ac4989ce931720078a90aece7"
  license "GPL-2.0-or-later"
  revision 5

  bottle do
    sha256 arm64_monterey: "c51846493f9bf53180929d9804e7e8f0a594e67334785a2f3ea3bbc3bec23a22"
    sha256 arm64_big_sur:  "7591ff1eca02603587c82b10f0713aab3aab0a4815416751f0ac4fa6ae8298ad"
    sha256 monterey:       "6266d230063d3ca5436c8865b1908053f96b940020c6290e8d9ff567760568e9"
    sha256 big_sur:        "d4a167f0b64440612f50fee22412c899fd33790722e21e4045ce283836c0183d"
    sha256 catalina:       "ccc97cd8a1b948e97d9eecb3c614eeb13bef1c80e4c643b83002878a7adef964"
    sha256 x86_64_linux:   "b8a2a5c72a02e65bb41b07cd4848d050fc6b5b8acf0d44db291891fe9306e1ff"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  # Added automake as a build dependency to update config files for ARM support.
  # Please remove in the future if there is a patch upstream which recognises aarch64 macOS.
  on_arm do
    depends_on "automake" => :build
  end

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
    # Workaround for ancient config files not recognizing aarch64 macos.
    if Hardware::CPU.arm?
      %w[config.guess config.sub].each do |fn|
        cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, fn
      end
    end

    args = %w[
      --without-cspice
      --without-cygwin
      --with-gif
      --with-jpeg
      --with-libtiff
      --without-pango
      --without-pnm
      --without-x
      --without-xscreensaver
    ]
    args << "--with-aqua" if OS.mac?

    system "./configure", *std_configure_args, *args
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
