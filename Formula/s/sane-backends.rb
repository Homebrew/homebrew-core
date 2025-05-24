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
    rebuild 1
    sha256 arm64_sequoia:  "73d9e6f08781212504191af29da392c4f0896ba8b7f8192276af15b97db1d32d"
    sha256 arm64_sonoma:   "0719713dac96d44d1f64d0e427c8c210e55796d93819693e796f8712759e1f70"
    sha256 arm64_ventura:  "2c26a72e1a02d2989c5f961635c40e28da1ca235d9fec0c89f6647e326761d08"
    sha256 arm64_monterey: "aac23e69bcfcdcdaf83b2ac5cc0dca17f324621a2a034bdcacffffd4138ec99b"
    sha256 sonoma:         "43895d634e21a8c8d4cb472cef60d106f72c15507483d055d30fb0a553908fa4"
    sha256 ventura:        "8379299b3089d0f27f9ae1c419338909509302a08c3108b92d7d25d6b04ad61c"
    sha256 monterey:       "6ac5e0c8740a6353dd927f01a7324a88f2deacdbebad1a0de9594d40e09eadfe"
    sha256 arm64_linux:    "5379d8676467d8b52148730986ab9397dcc39cc8b66477e8536181ecfb7cf6c5"
    sha256 x86_64_linux:   "2ffeeb34668acc8fe57e84f36ffe4c9cae0d00261c7e19558f62e1ec3eb02b11"
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
