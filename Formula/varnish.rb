class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://varnish-cache.org/_downloads/varnish-6.6.0.tgz"
  mirror "https://fossies.org/linux/www/varnish-6.6.0.tgz"
  sha256 "d5ff82f2041276dfaeb9a652a88b6d7287cfcf7ca345bb02c438fb65d2bca2e5"
  license "BSD-2-Clause"

  livecheck do
    url "https://varnish-cache.org/releases/"
    regex(/href=.*?varnish[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "f7f9fbe170b82b63e47a6357e9ccc66af7a89571b3e96b61d1b87b6a0b37dac3"
    sha256 big_sur:       "83994fe56e798d944b1d216ecf91e1474f2d254b34f79af531b0bf2d4f2e0b21"
    sha256 catalina:      "07b78fb097f6d78bb92d1915a71d8bd91ec1c6519166e6e2c960aebe97c41fab"
    sha256 mojave:        "05757e6f285bc5180ff096b2c3c91105b75cd179ba7b6946d58c3a1ff63c481d"
  end

  depends_on "docutils" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pcre"

  def install
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make", "install"
    (etc/"varnish").install "etc/example.vcl" => "default.vcl"
    (var/"varnish").mkpath
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/sbin/varnishd -n #{HOMEBREW_PREFIX}/var/varnish -f #{HOMEBREW_PREFIX}/etc/varnish/default.vcl -s malloc,1G -T 127.0.0.1:2000 -a 0.0.0.0:8080 -F"

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
