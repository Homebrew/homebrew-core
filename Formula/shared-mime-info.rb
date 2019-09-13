class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://gitlab.freedesktop.org/xdg/shared-mime-info/uploads/5349e18c86eb96eee258a5c1f19122d0/shared-mime-info-1.13.1.tar.xz"
  sha256 "6ea80a5bc7b20598f3b0f9f92942fdb4322245b79d7ed3c3ee18816fcb472cae"

  bottle do
    cellar :any
    sha256 "83c7aaef7e7943ea1621bfd54c673d917224dac87566912bf6a90b109a2cc3f6" => :mojave
    sha256 "36e18ec073774c56a27a39028aca64fa9eeb6a73614a055b69e6921b7eaf91c7" => :high_sierra
    sha256 "1fe68b5312260a4b784e70b77af595bc934c82103e5e2062f5eb5644b82809d9" => :sierra
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
