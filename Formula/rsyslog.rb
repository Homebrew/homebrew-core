class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2004.0.tar.gz"
  sha256 "5fc3d7b775f0879a40606d960491812a602e22f62e006ce027ed7bcf4c9f27d9"

  bottle do
    sha256 "303b469ac3cf428da388635d354f6814e5b2a2e86f63379c4e41f81d27836f65" => :catalina
    sha256 "ecc15313299515848fed850ca55c1f89c7dd6ffbb4bfb1b9cce88ef868ef6af8" => :mojave
    sha256 "f21ca13358222274057d8392207e0449c3229c583a28f12422ab1726bab7f0e2" => :high_sierra
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

  plist_options :manual => "rsyslogd -f #{HOMEBREW_PREFIX}/etc/rsyslog.conf -i #{HOMEBREW_PREFIX}/var/run/rsyslogd.pid"

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
