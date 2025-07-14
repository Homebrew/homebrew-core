class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://gitlab.com/-/project/429008/uploads/843c156420e211859e974f78f64c3ea3/sane-backends-1.4.0.tar.gz"
  sha256 "f99205c903dfe2fb8990f0c531232c9a00ec9c2c66ac7cb0ce50b4af9f407a72"
  license "GPL-2.0-or-later"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_sequoia: "0216c81f23f34c4ed8528ac75f3bb668b217619569b16ebfc9b38483c6ab4770"
    sha256 arm64_sonoma:  "90ff1226986965d15ab21286260ee3323140be3fe91c299bffae18c215cc2b47"
    sha256 arm64_ventura: "aa5d8003afa1bedfe0ce827f717afac8f8f372ebffd92d01661240eaf1fb2ce7"
    sha256 sonoma:        "7e5c5a8c11e1ec6fb70648e1413e736b5d814fe8dc89fc92634a18c08df524b4"
    sha256 ventura:       "f74beb185bd7120dd63fd6bc37e5bcad2465957dc6f22fb88565e5dababd62cd"
    sha256 arm64_linux:   "c3852b66436ad775efb69b9909252d993f49fc03f6cb632b518c4d8d4f675531"
    sha256 x86_64_linux:  "d9ef1834b9b578e87a81e1b2050eb939de23cc9febff41af035a2a2dbc0f1923"
  end

  head do
    url "https://gitlab.com/sane-project/backends.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
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
    system "./configure", "--enable-local-backends",
                          "--localstatedir=#{var}",
                          "--without-gphoto2",
                          "--with-usb=yes",
                          *std_configure_args
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
