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
    rebuild 1
    sha256 arm64_sequoia:  "73d9e6f08781212504191af29da392c4f0896ba8b7f8192276af15b97db1d32d"
    sha256 arm64_sonoma:   "0719713dac96d44d1f64d0e427c8c210e55796d93819693e796f8712759e1f70"
    sha256 arm64_ventura:  "2c26a72e1a02d2989c5f961635c40e28da1ca235d9fec0c89f6647e326761d08"
    sha256 arm64_monterey: "aac23e69bcfcdcdaf83b2ac5cc0dca17f324621a2a034bdcacffffd4138ec99b"
    sha256 sonoma:         "43895d634e21a8c8d4cb472cef60d106f72c15507483d055d30fb0a553908fa4"
    sha256 ventura:        "8379299b3089d0f27f9ae1c419338909509302a08c3108b92d7d25d6b04ad61c"
    sha256 monterey:       "6ac5e0c8740a6353dd927f01a7324a88f2deacdbebad1a0de9594d40e09eadfe"
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

  # Fix compilation failure with clang 16, remove in next version
  # https://gitlab.com/sane-project/backends/-/issues/774
  patch do
    url "https://gitlab.com/sane-project/backends/-/commit/e45ba84b665e3ac339e27e594d8651ee1577d638.diff"
    sha256 "4cdb099c77cf94aad013f8b8c4e064c5d009629a84da5b67947ce2c7b0829c3d"
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
