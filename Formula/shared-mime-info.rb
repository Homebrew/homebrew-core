class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://gitlab.freedesktop.org/xdg/shared-mime-info/uploads/0ee50652091363ab0d17e335e5e74fbe/shared-mime-info-2.1.tar.xz"
  sha256 "b2d40cfcdd84e835d0f2c9107b3f3e77e9cf912f858171fe779946da634e8563"
  license "GPL-2.0-only"

  livecheck do
    url "https://gitlab.freedesktop.org/api/v4/projects/1205/releases"
    regex(/shared-mime-info v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "49fd4c8b0f7cb6b3d45be48968613f8f26b0bded7f7c55b9e978c11d94efb513"
    sha256 cellar: :any, arm64_big_sur:  "c2c98a7a02e1b23f5c7f7baafe0e4b04f22a7b1a6df73912a7450ea73c162819"
    sha256 cellar: :any, monterey:       "eb8c22370434b81375766139e32b3d8f823a1569a8f3bccc3eaf1fe9f39f250a"
    sha256 cellar: :any, big_sur:        "4857d9f38c0f3cbf23984d60c4ec6280d84b457123d34b9c01e96f3deb8b0bb2"
    sha256 cellar: :any, catalina:       "8cb87ae2f3014998ecebab2d8c37ac9ff364f1164417420c4d8778a38ca17d29"
    sha256 cellar: :any, mojave:         "786d1c053d03676c985de3a7c15d764b69626f5d12e7e36e4048055bdc36413c"
    sha256               x86_64_linux:   "6099cf602b42eb8f23022b02c292b0bbdce2e22f4ff5b5e8f4d8a3c4575b298f"
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
