class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://gitlab.freedesktop.org/xdg/shared-mime-info/uploads/80c7f1afbcad2769f38aeb9ba6317a51/shared-mime-info-1.12.tar.xz"
  sha256 "18b2f0fe07ed0d6f81951a5fd5ece44de9c8aeb4dc5bb20d4f595f6cc6bd403e"

  bottle do
    cellar :any
    sha256 "0eb2f032c94d63083a2a33d3097465bc2cda368e58d92dd3ffe009446833bb9c" => :mojave
    sha256 "bfa90f488784ce2b8204dedfe72b78ea5125f9d0fcd9dcabe15897dda9534b27" => :high_sierra
    sha256 "befa98d6a05964524b246d0d34abe0301e58e3c13d3b8b6d9b7647e602be6f4f" => :sierra
    sha256 "d9af8ef829cd4060f0185dc8a43cecdbc256c9265c40729c5b50edc1b5e6bd04" => :el_capitan
  end

  head do
    url "https://gitlab.freedesktop.org/xdg/shared-mime-info.git"
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
