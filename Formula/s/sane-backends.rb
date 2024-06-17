class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://gitlab.com/sane-project/backends/uploads/83bdbb6c9a115184c2d48f1fdc6847db/sane-backends-1.3.1.tar.gz"
  sha256 "aa82f76f409b88f8ea9793d4771fce01254d9b6549ec84d6295b8f59a3879a0c"
  license "GPL-2.0-or-later"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "97de2c6a250cb1b8111547467d266161b842e2592c742276fc35b09193833b5a"
    sha256 arm64_ventura:  "8c8de024315a21d793327cb837dde29fd42c5adf74588be71d4fb0b3a0c638dd"
    sha256 arm64_monterey: "9306dcf8e0d171fad08538e45f4006528bc0a30e8c8317f6ae48c19eabc56890"
    sha256 sonoma:         "ebfb6563c7dd81bcf3e64458e300b3bf796a655745dff4dfda9827217f98b05c"
    sha256 ventura:        "fbacaf2ea55d47657fcd54e4f888ee3b8c9082ac5a5a3caa468b039f1e74a803"
    sha256 monterey:       "52b9c4bc5ecc9612cd8a3a02ee0e6968ce3df07658ff14849547611205f022bc"
    sha256 x86_64_linux:   "5958543bd7bd0b1d3f542bf8b98bcbd863e682a2ddda08ec2b4c1f55b4cb572b"
  end

  head do
    url "https://gitlab.com/sane-project/backends.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libusb"
  depends_on "net-snmp"

  uses_from_macos "python" => :build
  uses_from_macos "libxml2"

  on_linux do
    depends_on "systemd"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
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
