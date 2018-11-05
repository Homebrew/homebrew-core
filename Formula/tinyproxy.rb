class Tinyproxy < Formula
  desc "HTTP/HTTPS proxy for POSIX systems"
  homepage "https://www.banu.com/tinyproxy/"
  url "https://github.com/tinyproxy/tinyproxy/releases/download/1.10.0/tinyproxy-1.10.0.tar.xz"
  sha256 "59be87689c415ba0d9c9bc6babbdd3df3b372d60b21e526b118d722dbc995682"

  bottle do
    rebuild 2
    sha256 "8441582a64edc6c8a8c048b5a430631bba42adba9b59af52d5e27c3ade369f83" => :mojave
    sha256 "aed9559849395b90fc0fea4b1ff045418ffd108d83bb94474c1e1d31e738b9b4" => :high_sierra
    sha256 "c2ee54093bf8f4c6fb9a1dddaf878332f3827988df18e4a203fa45a88139a8a7" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build

  def install
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

    # Fix broken XML lint
    # See: https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=154624
    inreplace %w[docs/man5/Makefile docs/man8/Makefile], "-f manpage",
                                                         "-f manpage \\\n  -L"

    system "make", "install"
  end

  def post_install
    (var/"log/tinyproxy").mkpath
    (var/"run/tinyproxy").mkpath
  end

  plist_options :manual => "tinyproxy"

  def plist; <<~EOS
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
            <string>#{opt_sbin}/tinyproxy</string>
            <string>-d</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
  EOS
  end

  test do
    pid = fork do
      exec "#{sbin}/tinyproxy"
    end
    sleep 2

    begin
      assert_match /tinyproxy/, shell_output("curl localhost:8888")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
