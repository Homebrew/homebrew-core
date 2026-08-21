class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://gitlab.com/-/project/429008/uploads/843c156420e211859e974f78f64c3ea3/sane-backends-1.4.0.tar.gz"
  sha256 "f99205c903dfe2fb8990f0c531232c9a00ec9c2c66ac7cb0ce50b4af9f407a72"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "27298da0362d4c23dfeea65ba2e3a3d0b4852299cb80d94d806309776abb7adc"
    sha256 arm64_sequoia: "3fe51ef811ef943b28aa0a7d02e2b1c4eea7b4697a955ef0f82c2e83645f146d"
    sha256 arm64_sonoma:  "db367d04d3578258dce97d066bb138f7bed577a56b03245e70bc31743e636017"
    sha256 sonoma:        "50c480c2b051b99a6f31de7ec827db4e041163d888ac622dcf72b2c4191c5403"
    sha256 arm64_linux:   "d0d46eb5a83650c66567911610413d9623c356483ba39586f8f8cb5d7b89a676"
    sha256 x86_64_linux:  "7ecde9d4c8c9aeafdeacc8ed886c18ea91ee747c83e5d9ca1d1ecad894876903"
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

    # Some drivers require a lockfile
    (var/"lock/sane").mkpath
  end

  test do
    assert_match prefix.to_s, shell_output("#{bin}/sane-config --prefix")
  end
end
