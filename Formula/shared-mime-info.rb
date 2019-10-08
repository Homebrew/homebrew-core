class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://gitlab.freedesktop.org/xdg/shared-mime-info/uploads/aee9ae9646cbef724bbb1bd2ba146556/shared-mime-info-1.14.tar.xz"
  sha256 "c573e9cae423669878b990e5e4790bc924119841f482b36a25fd751147f44a26"

  bottle do
    cellar :any
    sha256 "4012c911f72c0d331f9120fd361ed41884a196f60711c7004e10111ec8b43164" => :catalina
    sha256 "ba411303e33f5745d6e82dc750935d66904c5cc57350b83b69f76ee14502f3a9" => :mojave
    sha256 "fe258b90982ccfda5aa6c1054cc3e8d27929adacecc5424338f20b52529c0ac2" => :high_sierra
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
