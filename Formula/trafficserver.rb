class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://downloads.apache.org/trafficserver/trafficserver-9.1.3.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-9.1.3.tar.bz2"
  sha256 "c8bf77b034b0da6c38d3ec9f3ca85ef1038aa046170e839308b0a59709d9afb6"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "ad1c4081325f16e88ab2e0a5b28fd40e73773ddd991aa58e6e34245ddb186e22"
    sha256 arm64_big_sur:  "56104bf78296d6ae59562fadeda12ea162c14a201c28cb17a5d492c9ecbb2d13"
    sha256 monterey:       "9514ddec436b6ca4e6b15745a82bc8e34a442c661422a603bfa5b9bd7c79746b"
    sha256 big_sur:        "4f106b8242e5f85b470d7ee182426a4fd7f10d4cb48c77cd15b2d494fdf0981a"
    sha256 catalina:       "cdef360aff3c14b9811e69da4c543bc62edbac14b02c36e3a1a8d70e856a07d2"
    sha256 x86_64_linux:   "de988a5a2170b86814d457217b72f7f5c0f82f166fbfbea233b25177f3282b0a"
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
  depends_on "openssl@1.1"
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
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
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
