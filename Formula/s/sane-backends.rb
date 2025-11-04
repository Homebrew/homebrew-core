class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://gitlab.com/-/project/429008/uploads/843c156420e211859e974f78f64c3ea3/sane-backends-1.4.0.tar.gz"
  sha256 "f99205c903dfe2fb8990f0c531232c9a00ec9c2c66ac7cb0ce50b4af9f407a72"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "f81a22b9525395d64cef165c6de06f74881552907238f7e0f1934d058faeb594"
    sha256 arm64_sequoia: "29dfa6f1c69f3008ed6f80def50a7478434540ae9d34a98f9ea2c9fc22976a04"
    sha256 arm64_sonoma:  "ba88016ee3c9ded4f68cce2ab6c532df4eabe9d22abec61795c5ec6613d3531b"
    sha256 sonoma:        "0ba7b3beaa7aed07689e9e76298e8eb9a4687d5697a89c94c21f0ad334f83ed9"
    sha256 arm64_linux:   "08fd943978f5f13dd3460508f5b8a48bea19025a4d4703b7389b0f1eabbc46af"
    sha256 x86_64_linux:  "ab6d2dea1f471d4c28bf4cc4843938337e701c55204b50c7304e5918feaf1116"
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
