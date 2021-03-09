class Webdis < Formula
  desc "Redis HTTP interface with JSON output"
  homepage "https://webd.is/"
  url "https://github.com/nicolasff/webdis/archive/0.1.13.tar.gz"
  sha256 "980343669d0eadee753e5f842dae21baf6cd6b15bfc3d454d5f2e802c741f6e0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "398144fc87be02ce44d2f3efb3d4db38aec4998897b12afb3d1ae8aadbedcc57"
    sha256 cellar: :any, big_sur:       "f5e12ff6ce0798c1e455e17588eabd16cb5a8cfebdcac6e3aa9d3ebd9111b5d2"
    sha256 cellar: :any, catalina:      "c05a90047556fb2c297313a7e8011d8fceba2e4689d5003d38793ae9fa59134f"
    sha256 cellar: :any, mojave:        "1de4b6e173b3a38abfb47045defec45b93e463a923d6441faf7158086dedd547"
  end

  depends_on "libevent"

  def install
    system "make"
    bin.install "webdis"

    inreplace "webdis.prod.json" do |s|
      s.gsub! "/var/log/webdis.log", "#{var}/log/webdis.log"
      s.gsub!(/daemonize":\s*true/, "daemonize\":\tfalse")
    end

    etc.install "webdis.json", "webdis.prod.json"
  end

  def post_install
    (var/"log").mkpath
  end

  plist_options manual: "webdis #{HOMEBREW_PREFIX}/etc/webdis.json"

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
              <string>#{opt_bin}/webdis</string>
              <string>#{etc}/webdis.prod.json</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <dict>
              <key>SuccessfulExit</key>
              <false/>
          </dict>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port
    cp "#{etc}/webdis.json", "#{testpath}/webdis.json"
    inreplace "#{testpath}/webdis.json", "\"http_port\":\t7379,", "\"http_port\":\t#{port},"

    server = fork do
      exec "#{bin}/webdis", "#{testpath}/webdis.json"
    end
    sleep 0.5
    # Test that the response is from webdis
    assert_match(/Server: Webdis/, shell_output("curl --silent -XGET -I http://localhost:#{port}/PING"))
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
