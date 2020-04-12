class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://gitlab.com/sane-project/backends/uploads/54f858b20a364fc35d820df935a86478/sane-backends-1.0.29.tar.gz"
  sha256 "aa027b4e5f59849cd41b8c26d54584cf31fffd986049019be6ad4140e11ea8ed"
  head "https://gitlab.com/sane-project/backends.git"

  bottle do
    sha256 "07216e961a590f3d9a00b43cae10b132ed5008309a410db93d68aa4dca824888" => :catalina
    sha256 "132822ae224a20672067f3c5017abe7d7b00af43bea92dbe051cc62a94f03a72" => :mojave
    sha256 "99eabfb87281a6a88c00d9b9c52da3bcbfe430b0f66088c6ea5a5d4e0caad170" => :high_sierra
    sha256 "1c8dd4cbc1bec193f3bca14d19d79a513b7336f276ce0f373088391d38621173" => :sierra
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
