class Wdfs < Formula
  desc "Webdav file system"
  homepage "http://noedler.de/projekte/wdfs/"
  url "http://noedler.de/projekte/wdfs/wdfs-1.4.2.tar.gz"
  sha256 "fcf2e1584568b07c7f3683a983a9be26fae6534b8109e09167e5dff9114ba2e5"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "795f6e2939f798aeea462d891b102cb80e32c5abb3586f8d57841843d2120f91"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "neon"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wdfs", "-v"
  end
end
