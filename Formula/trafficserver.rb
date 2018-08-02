class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=trafficserver/trafficserver-7.1.4.tar.bz2"
    sha256 "1c5213f8565574ec8a66e08529fd20060c1b9a6cd9b803ba9bbb3b9847651b53"

    needs :cxx11
  end

  bottle do
    sha256 "34d24867b84b672d3ba4c07066c15b2db0ee3fab29469e916f54728c808f4200" => :high_sierra
    sha256 "d871b084da0193a97c97ea9e5dd9b81be73ed7719f0185c797044d98951c558f" => :sierra
    sha256 "5267f82f7a7d59cd592b4ae5351f17a075ad2dc5fb5d6efb7f880cd9024ec232" => :el_capitan
  end

  head do
    url "https://github.com/apache/trafficserver.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build

    fails_with :clang do
      build 800
      cause "needs C++17"
    end
  end

  option "with-experimental-plugins", "Enable experimental plugins"

  depends_on "openssl"
  depends_on "pcre"

  def install
    ENV.cxx11 if build.stable?

    # Needed for OpenSSL headers
    if MacOS.version <= :lion
      ENV.append_to_cflags "-Wno-deprecated-declarations"
    end

    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --localstatedir=#{var}
      --sysconfdir=#{etc}/trafficserver
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework
      --with-group=admin
      --disable-silent-rules
    ]

    args << "--enable-experimental-plugins" if build.with? "experimental-plugins"

    system "autoreconf", "-fvi" if build.head?
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
    output = shell_output("#{bin}/trafficserver status")
    assert_match "Apache Traffic Server is not running", output
  end
end
