class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://downloads.apache.org/trafficserver/trafficserver-9.2.3.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-9.2.3.tar.bz2"
  sha256 "49686bf788f48f24f9db3454125856564a847cdc4520cde43dcdd5fed105fbf4"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "2e07c59461fe5eab8499d209dd9bafce7c0820d4d34de416cc0704dc9bade81d"
    sha256 arm64_ventura:  "0f7d16861f8df411de0ebafdebe40b08d8913c36aea679aa8d9748c42046c553"
    sha256 arm64_monterey: "e612b006d7e6f33b43268c11b09f06180bd96b5e3460d293b9bfa467b285119d"
    sha256 sonoma:         "e45d25f0c65506398365acebfd416ec0838e4aa0a8dbfa22b437e7b371d5ed09"
    sha256 ventura:        "173be953d453943f1551f3a4318534ff64a38ca4b75afbe07babf804e1e8705d"
    sha256 monterey:       "0e5329615db9b88b19ae7b8c3a0b9891226facfdb0ca5227c4bc1fa0b5c3795e"
    sha256 x86_64_linux:   "ffdaff4b79923b4c4898730e31cbba3ed24244dde6e43b7125195f3f68ce5be8"
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
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s

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
