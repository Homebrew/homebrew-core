class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.5/wxWidgets-3.1.5.tar.bz2"
  sha256 "d7b3666de33aa5c10ea41bb9405c40326e1aeb74ee725bb88f90f1d50270a224"
  license "wxWindows"
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "64286e7122dfb5fb4a2ff013f2a9ef10595f404d036908ca6279c2821f02cf43"
    sha256 cellar: :any,                 arm64_big_sur:  "00b2086f68be587c6ee848954845a81e1e4bda964dc4a8b8ec117d6acb54c833"
    sha256 cellar: :any,                 monterey:       "ee0ae69ee883fe648eec49b00c39780e1ccecf11dd8b1e1fd58ef01c92b08f03"
    sha256 cellar: :any,                 big_sur:        "b75599c4bb938ce01b3ddcce13c8cea3d7f329db85a1a63672eca1266621e857"
    sha256 cellar: :any,                 catalina:       "a9de66ca781fe633b958a0a7745b47fecd4ffb3fc9d7302757b057ded6c88e22"
    sha256 cellar: :any,                 mojave:         "974046c7307cca6cb5eec6ef6b06c57817f42782ef1cfa03ff1f4bb4a97190bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f20b0033ce08592ade30d821da88010582c6107e7269e112ab3bbd48ec887f66"
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+3"
    depends_on "libsm"
    depends_on "mesa-glu"
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--enable-clipboard",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--enable-display",
      "--enable-dnd",
      "--enable-graphics_ctx",
      "--enable-std_string",
      "--enable-svg",
      "--enable-unicode",
      "--enable-webviewwebkit",
      "--with-expat",
      "--with-libjpeg",
      "--with-libpng",
      "--with-libtiff",
      "--with-opengl",
      "--with-zlib",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic",
    ]

    if OS.mac?
      # Set with-macosx-version-min to avoid configure defaulting to 10.5
      args << "--with-macosx-version-min=#{MacOS.version}"
      args << "--with-osx_cocoa"
      args << "--with-libiconv"
    end

    system "./configure", *args
    system "make", "install"

    # wx-config should reference the public prefix, not wxwidgets's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxwidgets and wxpython headers,
    # which are linked to the same place
    inreplace "#{bin}/wx-config", prefix, HOMEBREW_PREFIX

    # For consistency with the versioned wxwidgets formulae
    bin.install_symlink "#{bin}/wx-config" => "wx-config-#{version.major_minor}"
    (share/"wx"/version.major_minor).install share/"aclocal", share/"bakefile"
  end

  test do
    system bin/"wx-config", "--libs"
  end
end
