class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.34.0.tar.gz"
  sha256 "18330a9764c55d2501b847aad267292bd96c2b12fa5c3b92909bd8d4563c80a9"

  bottle do
    sha256 "cf810ad399795d9a031783649e1f1d19df652d0e346d9c93b1569a6f8090a95e" => :high_sierra
    sha256 "edf1c58262540bc3d4409d6a74a5784114ce31e9481064c6a147d299d61fa0b3" => :sierra
    sha256 "fe4b4b7732000b54f6bcc09495920fa27d2f09f31b575d424b9f71b73e32ae6e" => :el_capitan
    sha256 "a3434bafdb1c54eb0ea50fcbabbbf87f241dac07dd68be55c4de344db3daa114" => :yosemite
    sha256 "2f41f4e354de6cb6cd95630ed396a2099753adef10a63e0304fba550097f6237" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libestr"

  resource "libfastjson" do
    url "http://download.rsyslog.com/libfastjson/libfastjson-0.99.8.tar.gz"
    sha256 "3544c757668b4a257825b3cbc26f800f59ef3c1ff2a260f40f96b48ab1d59e07"
  end

  resource "liblogging" do
    url "http://download.rsyslog.com/liblogging/liblogging-1.0.6.tar.gz"
    sha256 "338c6174e5c8652eaa34f956be3451f7491a4416ab489aef63151f802b00bf93"
  end

  # Remove for > 8.34.0
  # Fix "fatal error: 'liblogging/stdlog.h' file not found"
  # Upstream PR 14 May 2018 "pass liblogging cflags when building fmhttp and
  # imfile plugins"; see https://github.com/rsyslog/rsyslog/pull/2703
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/a4f4bb9/rsyslog/liblogging-cflags.diff"
    sha256 "f5d02e928783e34d0784136e7315a831f09309544d9b49a7087468063447c736"
  end

  def install
    resource("libfastjson").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}"
      system "make", "install"
    end

    resource("liblogging").stage do
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
