class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://varnish-cache.org/_downloads/varnish-6.3.1.tgz"
  sha256 "d1a26c7dad43b842c97e48f1c6422bb0b24c02cd6a74c53a2cf17e64da254175"

  bottle do
    sha256 "79ef87ddb0c271dd42b0729b4b79ffd6942e9b23fbdccfc423dcb9a302fbdce4" => :catalina
    sha256 "2ace791451ccfd648f0aabe1cc5db7c4adfabd35da5d920ffdad496ae278e9d6" => :mojave
    sha256 "16c112011697adab08a0d668a01ab64e9f1cc1ddee06a28974dbe4d3c74e60b2" => :high_sierra
  end

  depends_on "docutils" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pcre"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make", "install"
    (etc/"varnish").install "etc/example.vcl" => "default.vcl"
    (var/"varnish").mkpath
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/sbin/varnishd -n #{HOMEBREW_PREFIX}/var/varnish -f #{HOMEBREW_PREFIX}/etc/varnish/default.vcl -s malloc,1G -T 127.0.0.1:2000 -a 0.0.0.0:8080 -F"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/varnishd</string>
          <string>-n</string>
          <string>#{var}/varnish</string>
          <string>-f</string>
          <string>#{etc}/varnish/default.vcl</string>
          <string>-s</string>
          <string>malloc,1G</string>
          <string>-T</string>
          <string>127.0.0.1:2000</string>
          <string>-a</string>
          <string>0.0.0.0:8080</string>
          <string>-F</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/varnish/varnish.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/varnish/varnish.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/varnishd -V 2>&1")
  end
end
