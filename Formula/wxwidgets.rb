class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.7/wxWidgets-3.1.7.tar.bz2"
  sha256 "3d666e47d86192f085c84089b850c90db7a73a5d26b684b617298d89dce84f19"
  license "wxWindows"
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9043c93e511e5ad2ddec26406ca2a9a5b7887b61a3fe590ccc494cf609b4d30d"
    sha256 cellar: :any,                 arm64_big_sur:  "12f667f9bea4188b91060402e5edc8f80b35cb44bbe635898fa087c04ae008dc"
    sha256 cellar: :any,                 monterey:       "b81e1732b71ae86b348f6ff237bf740cad44995f6cef609c8ce91e54a7d86d61"
    sha256 cellar: :any,                 big_sur:        "dac357ec7aa4fdbd2c7a5d5d7ff162732d997b71871fdc366567b6629c0c0adf"
    sha256 cellar: :any,                 catalina:       "5a4dec6297c76d4d1b6f66f31fae608bca156527dd76e95925385559b4e4b032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edc81df56ac84c5680938a9d7c27c710f23990289090d3aa07ea32647c4de070"
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
