class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.4/wxWidgets-3.2.4.tar.bz2"
  sha256 "0640e1ab716db5af2ecb7389dbef6138d7679261fbff730d23845ba838ca133e"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9d6eda1e2e0a021a6bcff6e830a178887162485f28871b1035d8ae92cc33d03b"
    sha256 cellar: :any,                 arm64_ventura:  "0e61e20b856bffc27ff7666e720b0e75e3acffb55179aea7b978d3f2549e662d"
    sha256 cellar: :any,                 arm64_monterey: "b514b4cfd096e55a89bafec9d63f053d6a894ff33caffa23b5d190a642c00da5"
    sha256 cellar: :any,                 sonoma:         "52f4930411bf013d04c095e86bef0af34a4c10e5a39d42f72c86f01dd44d3944"
    sha256 cellar: :any,                 ventura:        "2bc267e85ced81e32d45eeb873cd3cb39a54fc9eebc4ffbacc4ab48baaa75a40"
    sha256 cellar: :any,                 monterey:       "dbf0ec95823a1b2afa2cf12d62a18cf6bc8f55a703e71b748c0aab0417673caa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bcf57776f52d7ad7a5a88d3f6a62e0367d75fe3f4c13f2028f155ea02219f17"
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
