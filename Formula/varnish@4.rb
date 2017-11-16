class VarnishAT4 < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://varnish-cache.org/_downloads/varnish-4.1.9.tgz"
  sha256 "22d884aad87e585ce5f3b4a6d33442e3a855162f27e48358c7c93af1b5f2fc87"

  bottle do
    sha256 "e6a4e3609fb8caec16a3e0a55abda963aa62f6e41d4457296062f1246f1af27e" => :high_sierra
    sha256 "feee2d796d10d27aab921d531d74be2e0a7ec789d5e5387d55d1628f0eb1d25a" => :sierra
    sha256 "8e8e30c902fbce8dc6ed1533bf604a9d4a197645240ca770fe51928a29ec3aaf" => :el_capitan
    sha256 "7ff168bb774232159547fdc251f4548e4e68cdcc7d01261b612872ef90c6030f" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "docutils" => :build
  depends_on "pcre"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make", "install"
    (etc/"varnish").install "etc/example.vcl" => "default.vcl"
    (var/"varnish").mkpath
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/varnish@4/sbin/varnishd -n #{HOMEBREW_PREFIX}/var/varnish -f #{HOMEBREW_PREFIX}/etc/varnish/default.vcl -s malloc,1G -T 127.0.0.1:2000 -a 0.0.0.0:8080"

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
