class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.1/wxWidgets-3.2.1.tar.bz2"
  sha256 "c229976bb413eb88e45cb5dfb68b27890d450149c09b331abd751e7ae0f5fa66"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d6147eeb082c14a69608cb5d827462d45829c921b63772f5620662d71d626381"
    sha256 cellar: :any,                 arm64_big_sur:  "70d9753a8424f931e7d964dbbb8880438e7f7d1cb2531724ccad102d30053ad9"
    sha256 cellar: :any,                 monterey:       "179fdc5c11122b3d98e8d7720521429ae38c498bfd69fd05ed9eefe63d9881f5"
    sha256 cellar: :any,                 big_sur:        "cc2ba3c2bb5bd9bce50fe6b7eef6b582fbfb8f5468da7a95f73787e2bec778ad"
    sha256 cellar: :any,                 catalina:       "3eb7623536992489e2224b36c6831328034ebbaeab59277791c578148805f091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd1dfab011909114af44d0949d6473e077355a226ac212db9261f04aa035c98f"
  end

  depends_on "jpeg-turbo"
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
    inreplace bin/"wx-config", prefix, HOMEBREW_PREFIX

    # For consistency with the versioned wxwidgets formulae
    bin.install_symlink bin/"wx-config" => "wx-config-#{version.major_minor}"
    (share/"wx"/version.major_minor).install share/"aclocal", share/"bakefile"
  end

  test do
    system bin/"wx-config", "--libs"
  end
end
