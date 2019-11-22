class Utimer < Formula
  desc "Multifunction timer tool"
  homepage "https://launchpad.net/utimer"
  url "https://launchpad.net/utimer/0.4/0.4/+download/utimer-0.4.tar.gz"
  sha256 "07a9d28e15155a10b7e6b22af05c84c878d95be782b6b0afaadec2f7884aa0f7"
  revision 1

  bottle do
    cellar :any
    sha256 "58144b80218183cb1cb0bdccd87baf86a4bddbab8b3107a2197227a15b6a4f27" => :catalina
    sha256 "01a5bce5e1e818932e0870eaed8586a23f3a6ca24504011005fc03d86992f63e" => :mojave
    sha256 "ef1faac8b5226cad7b83369c5139a370543316fd43102f7a8ccd15ab63f4fe6e" => :high_sierra
    sha256 "a2bb9673b9b7909dcb080f52ea6480d2d89f3ae0fdff3c599e17587ebce406e1" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Elapsed Time:", shell_output("#{bin}/utimer -t 0ms")
  end
end
