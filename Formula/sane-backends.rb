class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://gitlab.com/sane-project/backends/uploads/9e718daff347826f4cfe21126c8d5091/sane-backends-1.0.28.tar.gz"
  sha256 "31260f3f72d82ac1661c62c5a4468410b89fb2b4a811dabbfcc0350c1346de03"
  head "https://gitlab.com/sane-project/backends.git"

  bottle do
    sha256 "19a5dd6aab043b2552e4ddb785c4f41c184019a7854e5bf28054ee809839a81f" => :mojave
    sha256 "7e17e4e13a6b9d4c532c3f4f498711c016c0c23331a25e9c4fe2543c1241bebf" => :high_sierra
    sha256 "c1c278d995f33f438ad6009ba4928157dd2ca74ec17a344a57b7af972c64e190" => :sierra
    sha256 "6073b7b25829eb031616894fe6ea5c34408fed9b42d3b421e6eba94d6cbbf948" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libusb"
  depends_on "net-snmp"
  depends_on "openssl"

  def install
    # malloc lives in malloc/malloc.h instead of just malloc.h on macOS.
    # Merge request opened upstream: https://gitlab.com/sane-project/backends/merge_requests/90
    inreplace "backend/ricoh2_buffer.c", "#include <malloc.h>", "#include <malloc/malloc.h>"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--without-gphoto2",
                          "--enable-local-backends",
                          "--with-usb=yes"
    system "make", "install"
  end

  def post_install
    # Some drivers require a lockfile
    (var/"lock/sane").mkpath
  end

  test do
    assert_match prefix.to_s, shell_output("#{bin}/sane-config --prefix")
  end
end
