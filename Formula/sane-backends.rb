class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://gitlab.com/sane-project/backends/uploads/9e718daff347826f4cfe21126c8d5091/sane-backends-1.0.28.tar.gz"
  sha256 "31260f3f72d82ac1661c62c5a4468410b89fb2b4a811dabbfcc0350c1346de03"
  revision 1
  head "https://gitlab.com/sane-project/backends.git"

  bottle do
    sha256 "eb0b8abc41f1f1e948c9792f9ad4b2fd4ce81e4b22d788891e6e1c6d50380be8" => :mojave
    sha256 "74c223a3316de1e82146c48875bad045af577240e814ce194d5cd8e332d586cb" => :high_sierra
    sha256 "1017f23e986509ba65dd11570b2cc9298755829127c9d1994ef778a7522b61a5" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libusb"
  depends_on "net-snmp"
  depends_on "openssl@1.1"

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
