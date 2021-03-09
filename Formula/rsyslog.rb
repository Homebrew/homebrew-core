class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2102.0.tar.gz"
  sha256 "94ee0d0312c2edea737665594cbe4a9475e4e3b593e12b5b8ae3a743ac9c72a7"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url :homepage
    regex(/Current Version.+?v?(\d+(?:\.\d+)+)/im)
  end

  bottle do
    sha256 arm64_big_sur: "881bebe09c8a02fd07128884954316c8ebc636ca0c98961957d1a9d196d18778"
    sha256 big_sur:       "43592c8eb73fda51a9e93fbfa954932369d34e75d576cc6cac43aa65cd419e81"
    sha256 catalina:      "bf7c7f327aced675dfa37cbc86df0106cb9d8e2826155371a4b8ec7fc43a2cea"
    sha256 mojave:        "95b1f36183b0ec324fd66c7f691ba39305b676dcc46f81ba2aafb841537c855c"
  end

  depends_on "pkg-config" => :build
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
