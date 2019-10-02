class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://gitlab.freedesktop.org/xdg/shared-mime-info/uploads/aee9ae9646cbef724bbb1bd2ba146556/shared-mime-info-1.14.tar.xz"
  sha256 "c573e9cae423669878b990e5e4790bc924119841f482b36a25fd751147f44a26"

  bottle do
    cellar :any
    sha256 "f3ea628cd69f0a96060509628be3c698ab589498ea6138e17c8ba29d33918dfa" => :catalina
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
