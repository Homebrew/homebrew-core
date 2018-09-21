class Tinyproxy < Formula
  desc "HTTP/HTTPS proxy for POSIX systems"
  homepage "https://www.banu.com/tinyproxy/"
  url "https://github.com/tinyproxy/tinyproxy/releases/download/1.8.4/tinyproxy-1.8.4.tar.xz"
  sha256 "a41f4ddf0243fc517469cf444c8400e1d2edc909794acda7839f1d644e8a5000"

  bottle do
    rebuild 1
    sha256 "a2163705958c1475b4c044ac3e1e8f0a46f3e4a9e300fbaeaa78421bdc9dee10" => :mojave
    sha256 "7e7250cfbda60dcf40e291ce777842953bdfa573023ca28d2b09eefe41c0e523" => :high_sierra
    sha256 "f04c44c7119f0eac9c0ec0a9a48044808d9e2fc2f1a8c0ddf197206fa0683e4a" => :sierra
    sha256 "2ccb9fb5ba5dd782407fa1c6d261d57eaa4189c902e674cbed839c903e39c177" => :el_capitan
  end

  option "with-reverse", "Enable reverse proxying"
  option "with-transparent", "Enable transparent proxying"
  option "with-filter", "Enable url filtering"

  deprecated_option "reverse" => "with-reverse"

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
    ]

    args << "--enable-reverse" if build.with? "reverse"
    args << "--enable-transparent" if build.with? "transparent"
    args << "--enable-filter" if build.with? "filter"

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
