class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://gitlab.com/sane-project/backends/uploads/110fc43336d0fb5e514f1fdc7360dd87/sane-backends-1.2.1.tar.gz"
  sha256 "f832395efcb90bb5ea8acd367a820c393dda7e0dd578b16f48928b8f5bdd0524"
  license "GPL-2.0-or-later"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "16891b829a70d1ba93c7e78c01d530a1056b5a458e63be6fae053305601ccc44"
    sha256 arm64_monterey: "e30551208ab027ea52010f856be76623660ca21788b79e9a274084a1a89a1f2c"
    sha256 arm64_big_sur:  "9a688cb9f383fd208ce689f3feaea3ed0fe9ada761f296c8811dfdd9928689a4"
    sha256 ventura:        "196d903218ffcbd6d570be010ab8a414c616a5af0d2d28b2e71660e7c19727d0"
    sha256 monterey:       "cb82018f2956294ea6eaafdec36d74551ede36ab2c9967d920bee8a4cb4adf08"
    sha256 big_sur:        "61cab7702db52ce96ac99337e9dc15fe9196135e034f50ab6a94979b625f8b76"
    sha256 x86_64_linux:   "652541c2359077a7436822294aad78c140ea569bb3fd87cdfd649ff95a43ee8c"
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
  depends_on "openssl@1.1"

  uses_from_macos "python" => :build
  uses_from_macos "libxml2"

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
