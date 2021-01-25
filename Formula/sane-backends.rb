class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://gitlab.com/sane-project/backends/uploads/8bf1cae2e1803aefab9e5331550e5d5d/sane-backends-1.0.31.tar.gz"
  sha256 "4a3b10fcb398ed854777d979498645edfe66fcac2f2fd2b9117a79ff45e2a5aa"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/sane-project/backends.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "a489f51d1f8513292a3c5139e937f9bca35f85019035d3e5ae275fe3b3dcd990" => :big_sur
    sha256 "98d7eca159d5105a6bfa6dfd027830a16381347c22f92e75ab93a814380ff81b" => :arm64_big_sur
    sha256 "7b263e24809b81b27db7d43c4ce92e6c09c003055e3da0874b7d7282fb3a35c8" => :catalina
    sha256 "2bd03a03d1807d5d0e56695d567b1598696dc0e8e29ada67517665043854865b" => :mojave
    sha256 "3b54db3fec1723a2cbd5705cd1d9344791ff4942cb2a51d62e5c166f8cca9a9a" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libusb"
  depends_on "net-snmp"
  depends_on "openssl@1.1"

  if build.head?
    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
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
