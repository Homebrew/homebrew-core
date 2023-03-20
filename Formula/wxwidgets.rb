class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.2.1/wxWidgets-3.2.2.1.tar.bz2"
  sha256 "dffcb6be71296fff4b7f8840eb1b510178f57aa2eb236b20da41182009242c02"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "57f4e7e5c477ceedcfc61e2c0cc1e9fb43dcbc5460e178651ea72fa082743cca"
    sha256 cellar: :any,                 arm64_monterey: "eabe4d3be0802595b3690ea0a7e0ba928cd05323563fdc4c2c8eca0cc617fd5f"
    sha256 cellar: :any,                 arm64_big_sur:  "4440d70361440822a00750c2363c2d6eef2412863d8308c9571fe2352143799c"
    sha256 cellar: :any,                 ventura:        "5a7051517de061440de513389d20bc7e7a8cc1601571f836c553a1ba19c97702"
    sha256 cellar: :any,                 monterey:       "5f3399ebf5080fd205c39fe7da594f216175ab451fea181e59d5bd7d7e94295d"
    sha256 cellar: :any,                 big_sur:        "ed575bbb6e1cd8545facc7b14c83ca6d7b1c1ef64e2fdc93b7700217e6565612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e144d7720804e4c5873ca76be1b7e70c571a3b9d927f0913c29599070a27dad"
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
