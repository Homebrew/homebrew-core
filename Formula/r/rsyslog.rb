class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2408.0.tar.gz"
  sha256 "8bb2f15f9bf9bb7e635182e3d3e370bfc39d08bf35a367dce9714e186f787206"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "d282a4933466f1f307fb49ca53cbaa24de7701af10d419012feef8a7d2663cc7"
    sha256 arm64_sonoma:   "85a2b4770bca1bd700e9155f74f7ecf475a981e1b8691bf0cdf365005326c43d"
    sha256 arm64_ventura:  "29bca6782483abf2c44a0d2b5c2c97fe8e347b067905b23e0f2c68e51f65b9bf"
    sha256 arm64_monterey: "25cf1ad015a6a794e76e58933582b46ce33f4e5cdd6d4e6c85394e228b98b57e"
    sha256 sonoma:         "99bbb128bc35be80b3df66809d2440708905846435ef5a00403a4627df3ab2f0"
    sha256 ventura:        "0fa64a8a7ba89be4be249ef0963e082b59cb1e8a7e8be0e98a283fd8dac6e449"
    sha256 monterey:       "0b1db06fdf4e56f1de4734b210964855bdbb3a730ed433d89a88aaa7d8a7341b"
    sha256 x86_64_linux:   "63e3ff926e2ba9f5ad35878eb8d4024a76c8dd5eeacde9a556e4ba6d5b78497e"
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

    (buildpath/"rsyslog.conf").write <<~EOS
      # minimal config file for receiving logs over UDP port 10514
      $ModLoad imudp
      $UDPServerRun 10514
      *.* /usr/local/var/log/rsyslog-remote.log
    EOS
    etc.install buildpath/"rsyslog.conf"
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
