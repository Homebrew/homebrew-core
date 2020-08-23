class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2006.0.tar.gz"
  sha256 "d9589e64866f2fdc5636af4cae9d60ebf1e3257bb84b81ee953ede6a05878e97"
  license "GPL-3.0"

  bottle do
    sha256 "6e2da2c80153db338ae7acb282ee690fa888e11e3f2bc0c5d7cd86640e1d5264" => :catalina
    sha256 "a6292acf708905547dbaea460f92c59e5d1924506293afc751a349f8734a787b" => :mojave
    sha256 "fd426af7ddbe1611be30da51a5850f05d3496713b80c8f313e6763e9a245a2dd" => :high_sierra
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
