class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2010.0.tar.gz"
  sha256 "19b232f765c4ba7a35b91ef1f5f9af775f6ff78ef56bb7737a2ce79ccbb32b98"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url :homepage
    regex(/Current Version.+?v?(\d+(?:\.\d+)+)/im)
  end

  bottle do
    sha256 "128ed628f1b65a38f2e2d6463ab5d7ad82e2605b35a00db38e8282467cd3fbfe" => :catalina
    sha256 "eb44aad01f3736ee2c0c69e907c66ee82f31abb00ce1b101b1c32c66312112d1" => :mojave
    sha256 "25ce0e6d606ab2623f842f9d05a19dc7cea7efa13a8a0ec25df9ea6844a048ca" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libestr"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  resource "libfastjson" do
    url "https://download.rsyslog.com/libfastjson/libfastjson-0.99.8.tar.gz"
    sha256 "3544c757668b4a257825b3cbc26f800f59ef3c1ff2a260f40f96b48ab1d59e07"
  end

  def install
    resource("libfastjson").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-imfile
      --enable-usertools
      --enable-diagtools
      --disable-uuid
      --disable-libgcrypt
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    mkdir_p var/"run"
  end

  plist_options manual: "rsyslogd -f #{HOMEBREW_PREFIX}/etc/rsyslog.conf -i #{HOMEBREW_PREFIX}/var/run/rsyslogd.pid"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_sbin}/rsyslogd</string>
            <string>-n</string>
            <string>-f</string>
            <string>#{etc}/rsyslog.conf</string>
            <string>-i</string>
            <string>#{var}/run/rsyslogd.pid</string>
          </array>
          <key>StandardErrorPath</key>
          <string>#{var}/log/rsyslogd.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/rsyslogd.log</string>
        </dict>
      </plist>
    EOS
  end
end
