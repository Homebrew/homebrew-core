class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.2/shared-mime-info-2.2.tar.bz2"
  sha256 "418c480019d9865f67f922dfb88de00e9f38bf971205d55cdffab50432919e61"
  license "GPL-2.0-only"

  livecheck do
    url "https://gitlab.freedesktop.org/api/v4/projects/1205/releases"
    regex(/shared-mime-info v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "f7e0fb57ff2347839f5df016b9c57677b037b3a3835dea8638b76f89354b964b"
    sha256 cellar: :any, arm64_monterey: "6a9e8f01389c00cf8e3d3b7fbd9dc0b95d33744fcdb8bf3dca2c3db87c0d7cd1"
    sha256 cellar: :any, arm64_big_sur:  "c00d8c439285648cb14490b6f4bbb2111d16bd1cf7bbd386cc16ff9b1825a04a"
    sha256 cellar: :any, ventura:        "8cde9f9f6cf492ebb759bb76cf03ea7a3ea276b5a630a4f6080bbba28cf9bf87"
    sha256 cellar: :any, monterey:       "d279f9a9dfe8d9eb3aa22388b0ae41bdd284f44b35ef40b654f8d1c04929c488"
    sha256 cellar: :any, big_sur:        "3287f34793705e039a140e2614d3aafad8de654e5829515ffd3b77d024de6551"
    sha256 cellar: :any, catalina:       "406f54a852d1f7ea4e0e2d065495d825cd55a6e32132e0e1572c06010bfc89b6"
    sha256               x86_64_linux:   "42873f1d296084b1afe36a085f96b9b4074b1337b290cc0daf9a81859cf6766a"
  end

  head do
    url "https://gitlab.freedesktop.org/xdg/shared-mime-info.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "intltool" => :build
  end

  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "xmlto"

  uses_from_macos "libxml2"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    # Disable the post-install update-mimedb due to crash
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
      pkgshare.install share/"mime/packages"
      rmdir share/"mime"
    end
  end

  def post_install
    global_mime = HOMEBREW_PREFIX/"share/mime"
    cellar_mime = share/"mime"

    # Remove bad links created by old libheif postinstall
    rm_rf global_mime if global_mime.symlink?

    if !cellar_mime.exist? || !cellar_mime.symlink?
      rm_rf cellar_mime
      ln_sf global_mime, cellar_mime
    end

    (global_mime/"packages").mkpath
    cp (pkgshare/"packages").children, global_mime/"packages"

    system bin/"update-mime-database", global_mime
  end

  test do
    cp_r share/"mime", testpath
    system bin/"update-mime-database", testpath/"mime"
  end
end
