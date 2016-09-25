class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://freedesktop.org/~hadess/shared-mime-info-1.7.tar.xz"
  sha256 "eacc781cfebaa2074e43cf9521dc7ab4391ace8a4712902b2841669c83144d2e"

  bottle do
    cellar :any
    sha256 "aadb2c040a533a871655775fb098ce2fb572f3062ebf2cfc7883626c2b91ed8c" => :sierra
    sha256 "0b26d9f703f1781ba102e048fc454f42174b102c8cfeadf2a6f71da2b60d1b97" => :el_capitan
    sha256 "e42eb67b706cf232232aae7a7e537a17bbf1151689fb1943f8b1f257b829c4ee" => :yosemite
    sha256 "afad947215205d1091325d9eec5e53ce7f012e601f97f1f1bf61c3b424121bae" => :mavericks
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

  test do
    cp_r share/"mime", testpath
    system bin/"update-mime-database", testpath/"mime"
  end
end
