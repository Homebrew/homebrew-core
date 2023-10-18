class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.3/shared-mime-info-2.3.tar.bz2"
  sha256 "96ac085d82e2e654e40e34c13d97b74f6657357ee6b443d922695adcf548961c"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/xdg/shared-mime-info.git", branch: "master"

  livecheck do
    url "https://gitlab.freedesktop.org/api/v4/projects/1205/releases"
    regex(/shared-mime-info v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "c8c10b7f178cad9d256a152ce842e51700551680665ebd18813bfe61b8778919"
    sha256 cellar: :any, arm64_ventura:  "ff934b29242da40309ac06396a6db24c2bf4b085c4d2f2345c30f421ebcb7f14"
    sha256 cellar: :any, arm64_monterey: "df0461b3809d25a83f79a1bbbcac12ae82ebb25ec715566cb8cffe4ad9393999"
    sha256 cellar: :any, sonoma:         "6f06bb47b5e5e6304953b148e349f4f2b61f088cd4f3b9cd4fab7ef5071dd1d9"
    sha256 cellar: :any, ventura:        "948d258dc61609d4fdc9a37120a26226fa600a9ec5a813d1c4969db44634f49d"
    sha256 cellar: :any, monterey:       "36752744ee2b7dd8b76d7212a739590d7ffb8158006bfedec1ecc4c21613785d"
    sha256               x86_64_linux:   "e64b8fc08a9ad8af3b47cbe3d6b45057387ed7f10f2a77b85e1bb05253e4ef33"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "glib"

  uses_from_macos "libxml2"

  # Fix string literal concatenation
  # https://gitlab.freedesktop.org/xdg/shared-mime-info/-/merge_requests/251
  patch do
    url "https://gitlab.freedesktop.org/xdg/shared-mime-info/-/commit/12a3a6b1141c704fc594379af1808bb9008d588c.diff"
    sha256 "a63b61be35711561d819d68747c0cec1228819832f1062a8095bed73aad4c746"
  end

  # Fix false positive fdatasync detection on darwin
  # https://gitlab.freedesktop.org/xdg/shared-mime-info/-/merge_requests/252
  patch do
    url "https://gitlab.freedesktop.org/xdg/shared-mime-info/-/commit/7499ac1a85b2487b94e315e6b55c34bcf220295f.diff"
    sha256 "750630319628c3e313b633913873fccaf0ac640a0acd5953085733ec18bb1289"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
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
