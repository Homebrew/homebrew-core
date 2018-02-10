class Tinyproxy < Formula
  desc "HTTP/HTTPS proxy for POSIX systems"
  homepage "https://www.banu.com/tinyproxy/"
  url "https://github.com/tinyproxy/tinyproxy/releases/download/1.8.4/tinyproxy-1.8.4.tar.xz"
  sha256 "a41f4ddf0243fc517469cf444c8400e1d2edc909794acda7839f1d644e8a5000"

  bottle do
    cellar :any_skip_relocation
    sha256 "f62686118cef44aec1cecb27644f65779ff8d1c2c52216f78b2fed3fe8d74d3d" => :sierra
    sha256 "51cd6c92bb780eabbf856cbbc3dc08e3e5ad152042818c3d3a0761f28e414843" => :el_capitan
    sha256 "ea3bc9079b1c7b4aa0163b37c1bbe21fd971b2122f42cf9c2140ecd43d80b4a6" => :yosemite
  end

  option "with-reverse", "Enable reverse proxying"
  option "with-transparent", "Enable transparent proxying"
  option "with-filter", "Enable url filtering"

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build

  deprecated_option "reverse" => "with-reverse"

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
