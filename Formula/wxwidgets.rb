class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.0/wxWidgets-3.2.0.tar.bz2"
  sha256 "356e9b55f1ae3d58ae1fed61478e9b754d46b820913e3bfbc971c50377c1903a"
  license "wxWindows"
  revision 1
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "91183b19cfa6ad9e8cf6be3317acf8924ec801461412ddc85ff01c842b674249"
    sha256 cellar: :any,                 arm64_big_sur:  "008eee5e5ad865606071ff85498b15f8da51a6ffb1e4b78e4152be48ee85fe9b"
    sha256 cellar: :any,                 monterey:       "adb7e89f3c6fcae3889ea3461a1e8ee75f23119aa4c71393e018d6e1cc4d5640"
    sha256 cellar: :any,                 big_sur:        "f77eb837308ebef4ac7dbbf0b8c0d3ae858293f83e1cdfe4ac80e84172f3a5ba"
    sha256 cellar: :any,                 catalina:       "5bd8bbab2a4105045adaadf1f9cc95faf746746ca92a0d79fd0605a04b3a2837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df9a542046064054f9032bb277ec82329ee3f821332eb300b2d74a7da72e0ea6"
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
