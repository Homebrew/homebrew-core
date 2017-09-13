class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://freedesktop.org/~hadess/shared-mime-info-1.8.tar.xz"
  sha256 "2af55ef1a0319805b74ab40d331a3962c905477d76c086f49e34dc96363589e9"
  revision 1

  bottle do
    cellar :any
    sha256 "06cca38ff0a8777b3897caaafdbf701d3db751e21e5b0f2dacc0296bfebbfca9" => :sierra
    sha256 "f0dd34a6026ed39cb5db68f7c3291eab72eab3609e8caa94240ec3099d72e85f" => :el_capitan
    sha256 "5423f228303a77c6f4ff20fe40edd4b437750805f72ad20f3b58d8254cb8af19" => :yosemite
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
