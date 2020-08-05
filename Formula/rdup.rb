class Rdup < Formula
  desc "Utility to create a file list suitable for making backups"
  homepage "https://github.com/miekg/rdup"
  url "https://github.com/miekg/rdup/archive/1.1.15.tar.gz"
  sha256 "787b8c37e88be810a710210a9d9f6966b544b1389a738aadba3903c71e0c29cb"
  revision 2
  head "https://github.com/miekg/rdup.git"

  bottle do
    cellar :any
    sha256 "cf02c3004b312a3d90c6e47227f35e39319736270be76d7e4b0705568a21abec" => :catalina
    sha256 "fb091d60536b72e20dc5e1448d9876e7b2eaefd16d40f2bfbf7bba48059af348" => :mojave
    sha256 "417244fe66e0f47ab1afea65e9a52db01c15ac2f5db5e150ad65d80b2e85e2cc" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libarchive"
  depends_on "mcrypt"
  depends_on "nettle"
  depends_on "pcre"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    # tell rdup to archive itself, then let rdup-tr make a tar archive of it,
    # and test with tar and grep whether the resulting tar archive actually
    # contains rdup
    system "#{bin}/rdup /dev/null #{bin}/rdup | #{bin}/rdup-tr -O tar | tar tvf - | grep #{bin}/rdup"
  end
end
