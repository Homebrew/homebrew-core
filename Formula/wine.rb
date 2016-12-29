# NOTE: When updating Wine, please check Wine-Gecko and Wine-Mono for updates
# too:
#  - https://wiki.winehq.org/Gecko
#  - https://wiki.winehq.org/Mono
class Wine < Formula
  desc "Run Windows applications without a copy of Microsoft Windows"
  homepage "https://www.winehq.org/"
  head "git://source.winehq.org/git/wine.git"

  stable do
    url "https://dl.winehq.org/wine/source/1.8/wine-1.8.5.tar.bz2"
    mirror "https://downloads.sourceforge.net/project/wine/Source/wine-1.8.5.tar.bz2"
    sha256 "dee2a4959e5f90a89aaf04566c23f2926e9590f8968ea662afd81947fdb6f6d6"

    # Patch to fix screen-flickering issues. Still relevant on 1.8. Broken on 1.9.10.
    # https://bugs.winehq.org/show_bug.cgi?id=34166
    patch do
      url "https://bugs.winehq.org/attachment.cgi?id=52485"
      sha256 "59f1831a1b49c1b7a4c6e6af7e3f89f0bc60bec0bead645a615b251d37d232ac"
    end
  end

  bottle do
    rebuild 1
    sha256 "d507900232b6d4f8fa479f7405a7ca65e1da5020eeac1d4d1a4117b1540b1e33" => :sierra
    sha256 "ff061f8fc84916c5f87a6124e0fc84fec185b337b17ab56d2649b62086d7abe9" => :el_capitan
    sha256 "fc265a2c511030f6e65ff4a051105646e7706ebd6034292005e11bf3a8db2c17" => :yosemite
  end

  devel do
    url "https://dl.winehq.org/wine/source/2.0/wine-2.0-rc3.tar.bz2"
    mirror "https://downloads.sourceforge.net/project/wine/Source/wine-2.0-rc3.tar.bz2"
    sha256 "1e75f4a8fb005a1704b6e8540c128228c3f86fdf47ecbb56510282714fa4086b"
  end

  # note that all wine dependencies should declare a --universal option in their formula,
  # otherwise homebrew will not notice that they are not built universal
  def require_universal_deps?
    MacOS.prefer_64_bit?
  end

  if MacOS.version >= :el_capitan
    option "without-win64", "Build without 64-bit support"
    depends_on :xcode => ["8.0", :build] if build.with? "win64"
  end

  # Wine will build both the Mac and the X11 driver by default, and you can switch
  # between them. But if you really want to build without X11, you can.
  depends_on :x11 => :recommended
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libgphoto2"
  depends_on "little-cms2"
  depends_on "libicns"
  depends_on "libtiff"
  depends_on "sane-backends"
  depends_on "gnutls"
  depends_on "libgsm" => :optional

  # Patch to fix texture compression issues. Still relevant on 1.8.
  # https://bugs.winehq.org/show_bug.cgi?id=14939
  patch do
    url "https://bugs.winehq.org/attachment.cgi?id=52384"
    sha256 "30766403f5064a115f61de8cacba1defddffe2dd898b59557956400470adc699"
  end

  resource "gecko" do
    url "https://downloads.sourceforge.net/wine/wine_gecko-2.40-x86.msi", :using => :nounzip
    sha256 "1a29d17435a52b7663cea6f30a0771f74097962b07031947719bb7b46057d302"
  end

  resource "mono" do
    url "https://downloads.sourceforge.net/wine/wine-mono-4.5.6.msi", :using => :nounzip
    sha256 "ac681f737f83742d786706529eb85f4bc8d6bdddd8dcdfa9e2e336b71973bc25"
  end

  fails_with :clang do
    build 425
    cause "Clang prior to Xcode 5 miscompiles some parts of wine"
  end

  # These libraries are not specified as dependencies, or not built as 32-bit:
  # configure: libv4l, gstreamer-0.10, libcapi20, libgsm

  def install
    if build.with? "win64"
      args64 = ["--prefix=#{prefix}"]
      args64 << "--enable-win64"

      args64 << "--without-x" if build.without? "x11"

      mkdir "wine-64-build" do
        system "../configure", *args64

        system "make", "install"
      end
    end

    args = ["--prefix=#{prefix}"]

    # 64-bit builds of mpg123 are incompatible with 32-bit builds of Wine
    args << "--without-mpg123"

    args << "--without-x" if build.without? "x11"
    args << "--with-wine64=../wine-64-build" if build.with? "win64"

    mkdir "wine-32-build" do
      ENV.m32
      system "../configure", *args

      system "make", "install"
    end
    (pkgshare/"gecko").install resource("gecko")
    (pkgshare/"mono").install resource("mono")
  end

  def caveats
    s = <<-EOS.undent
      You may want to get winetricks:
        brew install winetricks
    EOS

    if build.with? "x11"
      s += <<-EOS.undent

        By default Wine uses a native Mac driver. To switch to the X11 driver, use
        regedit to set the "graphics" key under "HKCU\Software\Wine\Drivers" to
        "x11" (or use winetricks).

        For best results with X11, install the latest version of XQuartz:
          https://xquartz.macosforge.org/
      EOS
    end
    s
  end

  test do
    system "#{bin}/wine", "--version"
  end
end
