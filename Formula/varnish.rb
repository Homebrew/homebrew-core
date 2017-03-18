class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://repo.varnish-cache.org/source/varnish-5.1.0.tar.gz"
  sha256 "bd8c86a7492ebd5e2cb3868883caf2b7c107b9cee86968077d8c36b50ae6e599"

  bottle do
    sha256 "0aa3db9837c9beccee159b88f1aab8826908f3f808ceed91dae212dfe346aadd" => :sierra
    sha256 "69e3624c38b42f29d1fcd4a49cc837ba01fc137947215ed6a69560aef55ff3bc" => :el_capitan
    sha256 "0dac3f395ff229d059516ef8000ad3b484215edfdd7d9076a916413f212dcae0" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "docutils" => :build
  depends_on "pcre"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make", "install"
    (etc+"varnish").install "etc/example.vcl" => "default.vcl"
    (var+"varnish").mkpath
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/sbin/varnishd -n #{HOMEBREW_PREFIX}/var/varnish -f #{HOMEBREW_PREFIX}/etc/varnish/default.vcl -s malloc,1G -T 127.0.0.1:2000 -a 0.0.0.0:8080 -F"

  def plist; <<-EOS.undent
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
