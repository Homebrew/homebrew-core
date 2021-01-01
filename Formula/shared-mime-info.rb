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
    cellar :any
    sha256 "a89243613f2b5108a735abbe0a65ee02dcc39b5246a8f8b284c28cc9d8b86014" => :big_sur
    sha256 "bc94b21215784d4c26772de6b88ef5d1a4efa497f5c8479033e0d523f115c4e7" => :arm64_big_sur
    sha256 "5aefdc7964e569188cb67a49f4a428c64130f7c048ffd55106c656eb0c6caa25" => :catalina
    sha256 "26629464888f464e3aacfec50d6b5c28ecd91c9c56ae74a418eac49b07abc3a3" => :mojave
    sha256 "c548f5a23851ce6d807fd9e152c57e65ad99c3d0cf2cd40a473b55346935ec61" => :high_sierra
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
