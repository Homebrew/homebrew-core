# NOTE: When updating Wine, please check Wine-Gecko and Wine-Mono for updates
# too:
#  - https://wiki.winehq.org/Gecko
#  - https://wiki.winehq.org/Mono
class Wine < Formula
  desc "Run Windows applications without a copy of Microsoft Windows"
  homepage "https://www.winehq.org/"
  head "git://source.winehq.org/git/wine.git"

  stable do
    url "https://dl.winehq.org/wine/source/1.8/wine-1.8.6.tar.bz2"
    mirror "https://downloads.sourceforge.net/project/wine/Source/wine-1.8.6.tar.bz2"
    sha256 "b1797896eb3b63aab8a4753cc756d6211a0e85460146a1b52063ec79c13906d3"

    # Patch to fix screen-flickering issues. Still relevant on 1.8. Broken on 1.9.10.
    # https://bugs.winehq.org/show_bug.cgi?id=34166
    patch do
      url "https://bugs.winehq.org/attachment.cgi?id=52485"
      sha256 "59f1831a1b49c1b7a4c6e6af7e3f89f0bc60bec0bead645a615b251d37d232ac"
    end
  end

  bottle do
    sha256 "7f174f418fdb5c8ff34dd07b208cc9d21d7e8253bd84946134d2796009f93ba2" => :sierra
    sha256 "8f09f89e88059f6e03836a3b1a43f792f1c30330ddc4df2d19c2b4f82f4e6351" => :el_capitan
    sha256 "ce59d721723b0b0c64b65aeb8d9a1811985b40ec6aed861e66263b8f4815c177" => :yosemite
  end

  devel do
    url "https://dl.winehq.org/wine/source/2.x/wine-2.1.tar.xz"
    mirror "https://downloads.sourceforge.net/project/wine/Source/wine-2.1.tar.xz"
    sha256 "bfb9abf63691c93df28d9599aaa866dc2b4e27209b3b7b546df8a37d7d9d1e6e"
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
