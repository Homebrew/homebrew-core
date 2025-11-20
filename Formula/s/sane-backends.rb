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
    rebuild 1
    sha256 arm64_tahoe:   "0ed1250b6d610813518e0031b148e4a77a58d897a939ba61db37cb52dfbb0779"
    sha256 arm64_sequoia: "1345b682f1777a55c899b01c8be7d1726cfac208f3c616b7b0878eeaf32b4d9d"
    sha256 arm64_sonoma:  "90e80b8d37499be24f5ea283b634be85d66f1f3a94a74aec5c1c1968bcb2c53b"
    sha256 sonoma:        "8964bb2ec4807bbfb462d88607a59c51b5ad3e57dc6e396971c90ada1aabc6a2"
    sha256 arm64_linux:   "80f4598f610aabca7a0604e6cc6da5f49d466fc1f813728e354c4cd81704aad1"
    sha256 x86_64_linux:  "a630cae3cf511a9e1d197d323d0a5f6dbb0d5bfea21cd0cb66aadd5937a92362"
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
