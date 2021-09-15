class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://gitlab.com/sane-project/backends/uploads/104f09c07d35519cc8e72e604f11643f/sane-backends-1.0.32.tar.gz"
  sha256 "3a28c237c0a72767086202379f6dc92dbb63ec08dfbab22312cba80e238bb114"
  license "GPL-2.0-or-later"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "1ebc21e81f57ecb00c64799e448dff7606c8bea5a66123169af37bed634083ac"
    sha256 big_sur:       "bcdbaa5208359537721be14fbf2420ff07c573d62a480cb0fbafd5cb0be4334b"
    sha256 catalina:      "077644bb297e1e9e232d67ade77ef46bb8df7745a48444129e0b996d8fa2bec9"
    sha256 mojave:        "d7a6d9cb0ef356bef081454e6ee551d0975be4444ce77d048b625b9f44460ed2"
    sha256 x86_64_linux:  "51eaa1c638201959e754812033d8078f69af06a0b2746a13aed98aa2670e98fc"
  end

  head do
    url "https://gitlab.com/sane-project/backends.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libusb"
  depends_on "net-snmp"
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"

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
