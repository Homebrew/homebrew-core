class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=trafficserver/trafficserver-7.1.1.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-7.1.1.tar.bz2"
  sha256 "2c7ec32ef1460a76e5ee0e7caf95e9b6ca6b7c9612f135d280171bb2166ded36"

  bottle do
    sha256 "9dd3ea410cc75ae6c8b2ac58d9e10a98bbc9230b9519cbfb3feda994de442d6c" => :high_sierra
    sha256 "28efae63521a9b4e5e9818130fd6f359eb0a27a15622e99e547a6d9851a2ca4a" => :sierra
    sha256 "eca0c7caa9efa16d10684a0961e0d5564f1bc82916e0b1743c66d5967e056236" => :el_capitan
    sha256 "c0bccc71ecbd19da83e64b6273ae49705ec2d7e2966bb907a17ccade5d46f571" => :yosemite
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
