class Stoken < Formula
  desc "Tokencode generator compatible with RSA SecurID 128-bit (AES)"
  homepage "https://stoken.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/stoken/stoken-0.91.tar.gz"
  sha256 "419ed84000bc455ef77c78e3ebfd4c6fd2d932384563989f864becbafd51bcf4"

  bottle do
    cellar :any
    sha256 "e15fc74c664a18b8efc3d250c62e354b4dfc866878ee0605537de8e4fd228442" => :sierra
    sha256 "35e25f3a37d3578c14001a583ed584d95a08c3168edaddd1ee6f548a61ccd231" => :el_capitan
    sha256 "295ebb2ee6df4fa9f6aeaece981f90774746c2e30a564c8ce44471e15480a79d" => :yosemite
  end

  depends_on "gtk+3" => :optional
  if build.with? "gtk+3"
    depends_on "gnome-icon-theme"
    depends_on "hicolor-icon-theme"
  end
  depends_on "pkg-config" => :build
  depends_on "nettle"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/stoken", "show", "--random"
  end
end
