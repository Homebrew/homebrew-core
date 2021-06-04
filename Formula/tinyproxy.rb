class Tinyproxy < Formula
  desc "HTTP/HTTPS proxy for POSIX systems"
  homepage "https://tinyproxy.github.io/"
  url "https://github.com/tinyproxy/tinyproxy/releases/download/1.11.0/tinyproxy-1.11.0.tar.xz"
  sha256 "c1ec81cfc4c551d2c24e0227a5aeeaad8723bd9a39b61cd729e516b82eaa3f32"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "bd9b0b9f2217794521d4886a744f5f42a28d3dd29e2ee9c410c2698725eb9095"
    sha256 big_sur:       "ca40240c415c22ec760fcde6c735add7b3831ff8b1758d24d8821b7d04ef1299"
    sha256 catalina:      "e9d1db2c5652ccb5a0d5d22f7683208798dd3db7e310b71c5dd3e9fda7ccd57d"
    sha256 mojave:        "2c8d5680d40811fb8a9947015336624a7d3361c44f6381433cb81bab0f7d0179"
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build

  def install
    # conf.c:412:21: error: use of undeclared identifier 'LINE_MAX'
    # https://github.com/tinyproxy/tinyproxy/commit/7168a42624fb9ce3305c9e666e44cc8a533af5f6
    # Patch already accepted upstream, but not usable due to upstream refactor. Remove on next release.
    inreplace "src/acl.c", "#include <limits.h>\n", ""
    inreplace "src/common.h", "#  include	<pwd.h>\n", "#  include	<pwd.h>\n#  include	<limits.h>\n"

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --disable-regexcheck
      --enable-filter
      --enable-reverse
      --enable-transparent
    ]

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"log/tinyproxy").mkpath
    (var/"run/tinyproxy").mkpath
  end

  plist_options manual: "tinyproxy"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <false/>
          <key>ProgramArguments</key>
          <array>
              <string>#{opt_bin}/tinyproxy</string>
              <string>-d</string>
          </array>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port
    cp etc/"tinyproxy/tinyproxy.conf", testpath/"tinyproxy.conf"
    inreplace testpath/"tinyproxy.conf", "Port 8888", "Port #{port}"

    pid = fork do
      exec "#{bin}/tinyproxy", "-c", testpath/"tinyproxy.conf"
    end
    sleep 2

    begin
      assert_match "tinyproxy", shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
