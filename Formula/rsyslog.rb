class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.34.0.tar.gz"
  sha256 "18330a9764c55d2501b847aad267292bd96c2b12fa5c3b92909bd8d4563c80a9"

  bottle do
    sha256 "cd53ebf44f879d8786fbdf6faa3af2e68a180b0b96a49c37e82dfe2c366f5b69" => :high_sierra
    sha256 "3e7de1d3e48776cb66edc3fe9c67274d7be45c0b2bb5b5241477d1bd26001d8f" => :sierra
    sha256 "e984aeeeca6c29591d314f15e99595a50b46835e922cca90291ed5c7695c2057" => :el_capitan
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
