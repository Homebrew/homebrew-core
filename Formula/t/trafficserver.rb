class Trafficserver < Formula
  desc "HTTP/1.1 and HTTP/2 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://downloads.apache.org/trafficserver/trafficserver-9.2.5.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-9.2.5.tar.bz2"
  sha256 "c502b2c26756b104ce3114639abbe3fd8fb2c7cbd481f633f9bc1d7b1513a8ab"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia:  "1f0d8a25462ed5eec7f678df11ba5632898866a9c5a7d447c114c3c2b1c039d8"
    sha256 arm64_sonoma:   "d47a61ccdcbef9f123fb6a6a8492249caae35749cb2bfbfbcc32751a14352101"
    sha256 arm64_ventura:  "e4029c3e5c6a223351211525993e8e29cbaea96d21d62f6b329e892153121129"
    sha256 arm64_monterey: "56e3716e6389aa87ae1e551b81ea647ae3d2d61a11a023eb5c81e24f06386f5a"
    sha256 sonoma:         "dc7ca3c2c3b97b9a941c78b9224711c8aa5edda6a4794da1220a7e7cba51e8f5"
    sha256 ventura:        "1b624a60a4188923dde5ba0400a1e90d556e7743f6823965a381628035dd4af5"
    sha256 monterey:       "7d2b4c72f8a943f388266177551ecdc74c3982e6393773c7d33749cea7480d2c"
    sha256 x86_64_linux:   "f5d0bd9a32ec12c38a583411b4a14d59c896db2aa599ad762baf86fac805c6c5"
  end

  head do
    url "https://github.com/apache/trafficserver.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkg-config" => :build
  depends_on "hwloc"
  depends_on macos: :mojave # `error: call to unavailable member function 'value': introduced in macOS 10.14`
  depends_on "openssl@3"
  depends_on "pcre" # PCRE2 issue: https://github.com/apache/trafficserver/issues/8780
  depends_on "yaml-cpp"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    # Need to regenerate configure to fix macOS 11+ build error due to undefined symbols
    # See https://github.com/apache/trafficserver/pull/8556#issuecomment-995319215
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  fails_with gcc: "5" # needs C++17

  fails_with :clang do
    build 800
    cause "needs C++17"
  end

  def install
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?

    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --localstatedir=#{var}
      --sysconfdir=#{pkgetc}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --with-yaml-cpp=#{Formula["yaml-cpp"].opt_prefix}
      --with-group=admin
      --disable-tests
      --disable-silent-rules
      --enable-experimental-plugins
    ]

    system "autoreconf", "-fvi" if build.head? || OS.mac?
    system "./configure", *args

    # Fix wrong username in the generated startup script for bottles.
    inreplace "rc/trafficserver.in", "@pkgsysuser@", "$USER"

    inreplace "lib/perl/Makefile",
      "Makefile.PL INSTALLDIRS=$(INSTALLDIRS)",
      "Makefile.PL INSTALLDIRS=$(INSTALLDIRS) INSTALLSITEMAN3DIR=#{man3}"

    system "make" if build.head?
    system "make", "install"
  end

  def post_install
    (var/"log/trafficserver").mkpath
    (var/"trafficserver").mkpath

    config = etc/"trafficserver/records.config"
    return unless File.exist?(config)
    return if File.read(config).include?("proxy.config.admin.user_id STRING #{ENV["USER"]}")

    config.append_lines "CONFIG proxy.config.admin.user_id STRING #{ENV["USER"]}"
  end

  test do
    if OS.mac?
      output = shell_output("#{bin}/trafficserver status")
      assert_match "Apache Traffic Server is not running", output
    else
      output = shell_output("#{bin}/trafficserver status 2>&1", 3)
      assert_match "traffic_manager is not running", output
    end
  end
end
