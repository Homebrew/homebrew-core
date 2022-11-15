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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "edb8bfbbc0d73c3b3ab21a8cd6b5def66e6dcc077a72cc157c8a4d9c3ef00956"
    sha256 cellar: :any,                 arm64_monterey: "76e7c905c89560d11a2a2bb32fae3e315b0589c3dbdfedec1530c13b74aa3ded"
    sha256 cellar: :any,                 arm64_big_sur:  "855d074fcb1da69a300f99110d748921541b10861d745ed8be152d94b7b46e4b"
    sha256 cellar: :any,                 ventura:        "50a7b2a25c0c7e12d7ef3f0b148b70cbf1955f56476f80210bd710c5a4f1c50b"
    sha256 cellar: :any,                 monterey:       "2298c24d90acc7991a21b3807e4a412336df133cdc820be0bc8af848bea2908e"
    sha256 cellar: :any,                 big_sur:        "a1760b6dce6dd151748352e99a54ba3a8f5de2bd32d01a8b6370fce94b085738"
    sha256 cellar: :any,                 catalina:       "eed88d624813213f4f3272c7c0c6c1483b170642818e36aa14df76a495c4f333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f4fd75b1549902d61eee5a944b04048b45b4eb905e9929a8cc28011100cb2ce"
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
