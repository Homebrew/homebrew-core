class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://freedesktop.org/~hadess/shared-mime-info-1.8.tar.xz"
  sha256 "2af55ef1a0319805b74ab40d331a3962c905477d76c086f49e34dc96363589e9"

  bottle do
    cellar :any
    sha256 "181e7f618b5bdf09441314fea649dc4437c0ee8cc31975e093d13856cddff2d8" => :sierra
    sha256 "f36bb002e90dca88585e5507ae744c09d3909916da051d05e96bf53534072936" => :el_capitan
    sha256 "023e50b506b7401303b9a8a6b9ef5d4f3987786cc1d9456b6104af40df2d7498" => :yosemite
  end

  head do
    url "https://anongit.freedesktop.org/git/xdg/shared-mime-info.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "intltool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
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
  end

  def post_install
    system bin/"update-mime-database", HOMEBREW_PREFIX/"share/mime"
  end

  test do
    cp_r share/"mime", testpath
    system bin/"update-mime-database", testpath/"mime"
  end
end
