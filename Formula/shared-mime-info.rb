class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://freedesktop.org/~hadess/shared-mime-info-1.10.tar.xz"
  sha256 "c625a83b4838befc8cafcd54e3619946515d9e44d63d61c4adf7f5513ddfbebf"

  bottle do
    cellar :any
    sha256 "0eb2f032c94d63083a2a33d3097465bc2cda368e58d92dd3ffe009446833bb9c" => :mojave
    sha256 "bfa90f488784ce2b8204dedfe72b78ea5125f9d0fcd9dcabe15897dda9534b27" => :high_sierra
    sha256 "befa98d6a05964524b246d0d34abe0301e58e3c13d3b8b6d9b7647e602be6f4f" => :sierra
    sha256 "d9af8ef829cd4060f0185dc8a43cecdbc256c9265c40729c5b50edc1b5e6bd04" => :el_capitan
  end

  head do
    url "https://anongit.freedesktop.org/git/xdg/shared-mime-info.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "intltool" => :build
  end

  depends_on "intltool" => :build
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
