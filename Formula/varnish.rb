class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://varnish-cache.org/_downloads/varnish-6.4.0.tgz"
  sha256 "f636ba2d881b146f480fb52efefae468b36c2c3e6620d07460f9ccbe364a76c2"

  bottle do
    sha256 "b112adc0d1789bfe4bea6c3dd7777ce48bbdd8c5d2dd80d42b22b014f5fec988" => :catalina
    sha256 "432d0cbd340a6e12856a9cba72130142565632c88200386e6f7411dd787f8fa0" => :mojave
    sha256 "0113688047f37015d042d9650695f885a8fab888e029cd16ea3a62366f06c015" => :high_sierra
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
