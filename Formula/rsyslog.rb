class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.1907.0.tar.gz"
  sha256 "eb27535ece93174ef6b551c88467d2c9cd826b62479625bb881a53d50b079fb5"

  bottle do
    sha256 "c93d27bc72d47aaef94867e31a69f074884ce89d2c6daf37c38b0393577f789d" => :mojave
    sha256 "273f6dbbdb52f45c8ae89cbc16991c0d72b2fd0f6692d3d7c2832ff7e54af3fb" => :high_sierra
    sha256 "acf3962a074bead096f5bf44a254345e766a15c41c745126162b8163947bcca9" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libestr"

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

  plist_options :manual => "rsyslogd -f #{HOMEBREW_PREFIX}/etc/rsyslog.conf -i #{HOMEBREW_PREFIX}/var/run/rsyslogd.pid"

  def plist; <<~EOS
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
