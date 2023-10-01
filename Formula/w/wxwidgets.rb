class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.2.1/wxWidgets-3.2.2.1.tar.bz2"
  sha256 "dffcb6be71296fff4b7f8840eb1b510178f57aa2eb236b20da41182009242c02"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  revision 1
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "081e9f12a189c8cd0504ad38f39f2b2e59ff073c74660c50c2132567175becad"
    sha256 cellar: :any,                 arm64_ventura:  "f51d1012d079c411bee043c2126527e85b7b2a0e5b0273f36d7d9ed7b606a18f"
    sha256 cellar: :any,                 arm64_monterey: "875b133fa4aae0a1b0fa72c3f972c1a2f22004e1331f5553811eb3124a43ee25"
    sha256 cellar: :any,                 arm64_big_sur:  "049d670fbf92b640e97382159a2763fd1f14948d62cd131977fe08443a7eed6b"
    sha256 cellar: :any,                 sonoma:         "5e18a809e1b72a50abf863140cbce45af1ee70f74c7ce11a8b11549d93b1d05b"
    sha256 cellar: :any,                 ventura:        "6f415a469158fd5b3b6c1ce03d37c8bc04a79d5059902bf065b2d2efd8a1884e"
    sha256 cellar: :any,                 monterey:       "5f8d9b117225aaa7006ec3b80713b1bb5931926294b1c3fa705bfc89d7e66db1"
    sha256 cellar: :any,                 big_sur:        "82a319e267eeb62ebda44276cc856237aeebb57e83362eed35f33a487cfd1262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca8b1059a400171a8fcee66ddc9f4b008064afd0c993ebd016890362c7aaaa88"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pcre2"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gtk+3"
    depends_on "libsm"
    depends_on "mesa-glu"
  end

  def install
    # Remove all bundled libraries excluding `nanosvg` which isn't available as formula
    %w[catch pcre].each { |l| (buildpath/"3rdparty"/l).rmtree }
    %w[expat jpeg png tiff zlib].each { |l| (buildpath/"src"/l).rmtree }

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
      "--disable-dependency-tracking",
      "--disable-tests",
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
