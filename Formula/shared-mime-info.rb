class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://freedesktop.org/~hadess/shared-mime-info-1.8.tar.xz"
  sha256 "2af55ef1a0319805b74ab40d331a3962c905477d76c086f49e34dc96363589e9"
  revision 1

  bottle do
    cellar :any
    sha256 "d7ca64902748a28cc734fd835a7b85d9973115e33731291fba2e1bcf44eee9ea" => :sierra
    sha256 "18b0140f44ab9b54a2e11d0df999d7628b03f1e50257cd35b0d080b9ed519e1f" => :el_capitan
    sha256 "46b2ace2e454f893464cd674d723e54d096219470513ae639d6681155e96b364" => :yosemite
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
