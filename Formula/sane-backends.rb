class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  license "GPL-2.0-or-later"

  stable do
    url "https://gitlab.com/sane-project/backends/uploads/7d30fab4e115029d91027b6a58d64b43/sane-backends-1.1.1.tar.gz"
    sha256 "dd4b04c37a42f14c4619e8eea6a957f4c7c617fe59e32ae2872b373940a8b603"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "5ce5536fb913f7a9da86681e0dfe280024f06243ffc34e6290c74bec3ca0beb4"
    sha256 arm64_big_sur:  "5e975ebd14b5abc14a27045bfdeba6a35b67fdefb3b3bfb41e31147329ac5ddf"
    sha256 monterey:       "3d8d4820d67a24d31aeef2252a52fdfe295ac9fa6ac62b9646b9c48af0867a79"
    sha256 big_sur:        "bc17ea2f5083c867e376d47b21b5e9ca03f44cd4e3c9954a17ec0532c9ae0c9a"
    sha256 catalina:       "0524e31c3e201f125b48c7d64e6c4426bfed3f625719eafcb18c593e18904320"
    sha256 x86_64_linux:   "587c72a27734165d08444ac71255802943a67a59f40f7b922792aa1cbea4e7a8"
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
