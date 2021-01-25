class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2012.0.tar.gz"
  sha256 "d74cf571e6bcdf8a4c19974afd5e78a05356191390c2f80605a9004d1c587a0e"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url :homepage
    regex(/Current Version.+?v?(\d+(?:\.\d+)+)/im)
  end

  bottle do
    sha256 "209ec821a42fc9571c953528bfec86b08534bb434184645264317eb36f919527" => :big_sur
    sha256 "f5831c9c196b460d9d188ebf66a0bae6d3f0fc89e7dc85ba3e2a305fd83c2e8d" => :arm64_big_sur
    sha256 "c1abf89226e00de3abc82c3910afa530b791637dc15d45fcb3cc4eb392f39ff8" => :catalina
    sha256 "c58fb001a665dd9e691d833ec9d0e5061003af7aaaf8c9d911c430c429f17567" => :mojave
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
