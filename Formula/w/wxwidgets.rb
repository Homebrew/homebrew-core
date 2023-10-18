class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.3/wxWidgets-3.2.3.tar.bz2"
  sha256 "c170ab67c7e167387162276aea84e055ee58424486404bba692c401730d1a67a"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "21341a59f6592ce87b7ef645893ff51d0e401c5de286d3d00eb3aea7c38de924"
    sha256 cellar: :any,                 arm64_ventura:  "1b03118b5e3d89b0c1e1a5fca3e98e6adbf0b7c1d1cd5e5ef452d1cd3c0445ac"
    sha256 cellar: :any,                 arm64_monterey: "ea12eb9bb3d3a01a3a5d5acfcac0556a5bf178eac2cf64945718bcbaf38dcdb1"
    sha256 cellar: :any,                 sonoma:         "dca16bc2fdaffa03b1406cdc8ad0c45c22bdd07d4764bd12b8b6d44e9a95a976"
    sha256 cellar: :any,                 ventura:        "544c68fe643fe642b24c7c459faa13a40873e2579b30c89dd88e87140c8167d6"
    sha256 cellar: :any,                 monterey:       "0d21f00a77f355ca3ec5f78d0c34f535a60d422c06f74eee0cabc466c56b98da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6b2e0bdc1ffbed875b419a155c1fee75125a7fc2633ef56a4e7aafb0dd5fd60"
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
