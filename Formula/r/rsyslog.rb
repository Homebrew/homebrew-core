class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2510.0.tar.gz"
  sha256 "a70a9834186859539a6a4d1c7b3f68c23897e805829b764a45e92cb0cc95e66a"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "0b2e0bf5c8c9d2c08ce286f8d3ecafe9df9b289bca7e7af78341ab5d09ded214"
    sha256 arm64_sequoia: "3f396b4ad295039d023feed5d79cb3f04c8c8228d93bf81b182faea1f9c5a27a"
    sha256 arm64_sonoma:  "543a3fe12224e76dbebb2f8e3a20aea33bdb782966903de0acdb9f67be8f3069"
    sha256 sonoma:        "164c28103f9a4a11fc69ed5b0c0bda884401da6dd9e71466db75716f7d29f2e5"
    sha256 arm64_linux:   "3367a4af44d9307989ca72ad2ba30d2294b70abdcd6ca9b2e70bb7290d852371"
    sha256 x86_64_linux:  "14c1f1b2fd17d541b8de9b8bf424760c8f7845410741eb075df5c65ed66a7197"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libestr"
  depends_on "libfastjson"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "./configure", "--enable-imfile",
                          "--enable-usertools",
                          "--enable-diagtools",
                          "--disable-uuid",
                          "--disable-libgcrypt",
                          "--enable-gnutls",
                          *std_configure_args
    system "make"
    system "make", "install"

    (buildpath/"rsyslog.conf").write <<~EOS
      # minimal config file for receiving logs over UDP port 10514
      $ModLoad imudp
      $UDPServerRun 10514
      *.* #{var}/log/rsyslog-remote.log
    EOS
    etc.install buildpath/"rsyslog.conf"

    (var/"run").mkpath
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
