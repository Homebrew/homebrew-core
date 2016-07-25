class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=trafficserver/trafficserver-6.1.1.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-6.1.1.tar.bz2"
  sha256 "67ddd7fc79e4435f353b2aa8937a7b205f217ca15beba3adb5213a92f9527d8b"

  bottle do
    sha256 "c8fa833d763a36c2f80112b062bae83c8a91873a5296cacd9894c6134f8170a6" => :el_capitan
    sha256 "f3205d51a3cca216b838cd41e4e455d0c3efb082672651eaccc1a84149afeb67" => :yosemite
    sha256 "80b1e7d13bae8b827599000a718ec659a559f494b379aa0d250a99eb1a60e6a4" => :mavericks
  end

  head do
    url "https://github.com/apache/trafficserver.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  option "with-spdy", "Build with SPDY protocol support"
  option "with-experimental-plugins", "Enable experimental plugins"

  depends_on "openssl"
  depends_on "pcre"

  if build.with? "spdy"
    depends_on "spdylay"
    depends_on "pkg-config" => :build
  end

  needs :cxx11

  def install
    ENV.cxx11
    # Needed for correct ./configure detections.
    ENV.enable_warnings
    # Needed for OpenSSL headers on Lion.
    ENV.append_to_cflags "-Wno-deprecated-declarations"

    (var/"log/trafficserver").mkpath
    (var/"trafficserver").mkpath

    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --localstatedir=#{var}
      --sysconfdir=#{etc}/trafficserver
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-group=admin
      --disable-silent-rules
    ]

    args << "--enable-spdy" if build.with? "spdy"
    args << "--enable-experimental-plugins" if build.with? "experimental-plugins"

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args

    # Fix wrong username in the generated startup script for bottles.
    inreplace "rc/trafficserver.in", "@pkgsysuser@", "$USER"
    if build.with? "experimental-plugins"
      # Disable mysql_remap plugin due to missing symbol compile error:
      # https://issues.apache.org/jira/browse/TS-3490
      inreplace "plugins/experimental/Makefile", " mysql_remap", ""
    end

    system "make" if build.head?
    system "make", "install"
  end

  def post_install
    config = etc/"trafficserver/records.config"
    return unless File.exist?(config)
    return if File.read(config).include?("proxy.config.admin.user_id STRING #{ENV["USER"]}")

    config.append_lines "CONFIG proxy.config.admin.user_id STRING #{ENV["USER"]}"
  end

  test do
    assert_match "Apache Traffic Server is not running.", shell_output("#{bin}/trafficserver status").chomp
  end
end
