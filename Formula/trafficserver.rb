class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://downloads.apache.org/trafficserver/trafficserver-9.1.4.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-9.1.4.tar.bz2"
  sha256 "186cc796d9d783c7c9313d855785b04b8573234b237802b759939c002a64b1df"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "87bea1b8122598dd3c529135221dd31c2fa9b25d8237d0f719af47ac28d50903"
    sha256 arm64_monterey: "bec943f9ccc45cd39cbe3da176a4a8279a6ef16525457b9c29bd1428a6d74ce3"
    sha256 arm64_big_sur:  "3f8ba6b6234a3551c270cb62d3b14c5902ff3586b5d2be2718fced1aa34061ee"
    sha256 ventura:        "3386ec7a4a5dbc28974c26378e9520caca6e38ca1957f8946370de83a8f3e926"
    sha256 monterey:       "8f3ce83f3cea5b614e058f5ec01474d01e5db115a22441de27c690b0039f0a85"
    sha256 big_sur:        "be85e056a66aff3010a2724a7401dc26f811ba63da7ca451c90db3505911de65"
    sha256 x86_64_linux:   "75b329a3e0ede556c5a378fb8de7d8531904a9b9fe1fe59cfcf84450c8265ffb"
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
  depends_on "pcre"
  depends_on "yaml-cpp"

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
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

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
