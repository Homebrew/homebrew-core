class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2302.0.tar.gz"
  sha256 "25415f85b662615ce3c83077d53758029e8743cb5929044bfd3564e3d626a3b9"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "ea07ecd8c1ae19c9eaf4aa6de15967db259e6337a42edb618337eaa22428e659"
    sha256 arm64_monterey: "c0093e2af230c0326c732e344456d4331675243fa4d5d1d09d25790a7a28c111"
    sha256 arm64_big_sur:  "62a189e54933f372b8ff1b09a917a2d6318c7dee4728ac78395eeefd4d2f335b"
    sha256 ventura:        "f5fdfa5aace6cb3b7cdfca78c9484b0136842a1dc253e15e5f976effe094216c"
    sha256 monterey:       "73b16409f73ab1797036defbeac5e1b69cf9ab3846d87d3bf385b37528d5d573"
    sha256 big_sur:        "ccf0a584c9a4ea5c733d2c71e34b58d1bc70de88fbc3f087c56555aec513081f"
    sha256 x86_64_linux:   "a6563955f83d00e63a62c27490c9c4fc6102b0227d9c33d2e13763eba5ef1eb0"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libestr"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  resource "libfastjson" do
    url "https://download.rsyslog.com/libfastjson/libfastjson-0.99.9.tar.gz"
    sha256 "a330e1bdef3096b7ead53b4bad1a6158f19ba9c9ec7c36eda57de7729d84aaee"
  end

  def install
    resource("libfastjson").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-imfile",
                          "--enable-usertools",
                          "--enable-diagtools",
                          "--disable-uuid",
                          "--disable-libgcrypt",
                          "--enable-gnutls"
    system "make"
    system "make", "install"

    (etc/"rsyslog.conf").write <<~EOS
      # minimal config file for receiving logs over UDP port 10514
      $ModLoad imudp
      $UDPServerRun 10514
      *.* /usr/local/var/log/rsyslog-remote.log
    EOS
  end

  def post_install
    mkdir_p var/"run"
  end

  service do
    run [opt_sbin/"rsyslogd", "-n", "-f", etc/"rsyslog.conf", "-i", var/"run/rsyslogd.pid"]
    keep_alive true
    error_log_path var/"log/rsyslogd.log"
    log_path var/"log/rsyslogd.log"
  end

  test do
    result = shell_output("#{opt_sbin}/rsyslogd -f #{etc}/rsyslog.conf -N 1 2>&1")
    assert_match "End of config validation run", result
  end
end
