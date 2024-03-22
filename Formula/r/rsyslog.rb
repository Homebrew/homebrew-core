class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2402.0.tar.gz"
  sha256 "acbdd8579489df36b4a383dc6909a61b7623807f0aff54c062115f2de7ea85ba"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "196ed6954bda8be483d4003a02a73f7a3f23f7ab7fae7a92a862b1cbed148ac7"
    sha256 arm64_ventura:  "cdc3f7386313663a95c106e3fa8b746d776cd2888a581cc2c6cbf1c432c91293"
    sha256 arm64_monterey: "a528e1ca20a46dc99cfa05dc581567ab00b66331066c0a3f6bd80a06505c9126"
    sha256 sonoma:         "fe3a648f7fe0069483813b42acf80f4fc71a077d4f52c443a77cdd2a99a12e9d"
    sha256 ventura:        "b6a398627abeaf67865dbf7b151658f3220b0d6042ec861554cab478972dbe61"
    sha256 monterey:       "a259eb0b72b9eb01b265a2facc42a71d4da9ae0d75bd2dc44d19f43573b24bdb"
    sha256 x86_64_linux:   "c0fa01823786a057d0ae0ca52f4b897bc9b8010a31e83c93a15743f4dd8f704e"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libestr"
  depends_on "libfastjson"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
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
