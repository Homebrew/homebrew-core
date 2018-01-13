class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=trafficserver/trafficserver-7.1.2.tar.bz2"
  sha256 "413e7d5b2aee71c4403a00203d91b99544eecd1e36e47153240d24c0e4dad375"

  bottle do
    rebuild 1
    sha256 "84555aa82d766a0ad65891591f308f660c25ce17ab390c32d434e3cb3b70ecb6" => :high_sierra
    sha256 "a0bfb2d4b4ae2cbf45633290daa870c3aa67a3df301482536c7c7c1dad34043f" => :sierra
    sha256 "9a9515884155903c8300357012cd54d0c424e5f26d1090efee079c79341d3444" => :el_capitan
  end

  head do
    url "https://github.com/apache/trafficserver.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  option "with-experimental-plugins", "Enable experimental plugins"

  depends_on "openssl"
  depends_on "pcre"

  needs :cxx11

  def install
    ENV.cxx11

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
