class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://gitlab.freedesktop.org/xdg/shared-mime-info/uploads/5349e18c86eb96eee258a5c1f19122d0/shared-mime-info-1.13.1.tar.xz"
  sha256 "6ea80a5bc7b20598f3b0f9f92942fdb4322245b79d7ed3c3ee18816fcb472cae"

  bottle do
    cellar :any
    sha256 "aa8d4c56a94505b37c58935aee01777f87623a4ca9ad9e01276103cce877ce30" => :mojave
    sha256 "9a1d0b3325e604b5335b1b93f2db1b0c341430188c72523a5aba15dea4b85d1b" => :high_sierra
    sha256 "08383865a6b8460916bed3239b08e4c683573cd82a7bd0a351067c6f0f9f572a" => :sierra
  end

  head do
    url "https://gitlab.freedesktop.org/xdg/shared-mime-info.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "intltool" => :build
  end

  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    # Disable the post-install update-mimedb due to crash
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-update-mimedb
    ]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
    pkgshare.install share/"mime/packages"
    rmdir share/"mime"
  end

  def post_install
    ln_sf HOMEBREW_PREFIX/"share/mime", share/"mime"
    (HOMEBREW_PREFIX/"share/mime/packages").mkpath
    cp (pkgshare/"packages").children, HOMEBREW_PREFIX/"share/mime/packages"
    system bin/"update-mime-database", HOMEBREW_PREFIX/"share/mime"
  end

  test do
    cp_r share/"mime", testpath
    system bin/"update-mime-database", testpath/"mime"
  end
end
