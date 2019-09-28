class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "http://download.redis.io/releases/redis-5.0.5.tar.gz"
  sha256 "2139009799d21d8ff94fc40b7f36ac46699b9e1254086299f8d3b223ca54a375"
  head "https://github.com/antirez/redis.git", :branch => "unstable"

  bottle do
    cellar :any_skip_relocation
    sha256 "c386b0f43f9750c3dd7c86be09920fbf4215bbbff239979db9d1359f5a2bdb63" => :catalina
    sha256 "eb5538dadb10570c5a8aa9e8aafa5d21b7747e7597c92954916b9b6ca55ae407" => :mojave
    sha256 "e9de9e750d86c5f63ea3e60cd75fbdf9f8162494938ed14616a2dc4490577558" => :high_sierra
    sha256 "a519190fdd7b8d23d9faa3e2f512830b6c272b396770811d9a72f1137b485f6f" => :sierra
  end

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = "-arch #{MacOS.preferred_arch}"

    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", var/"run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.sub!  /^bind .*$/, "bind 127.0.0.1 ::1"
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
  end

  plist_options :manual => "redis-server #{HOMEBREW_PREFIX}/etc/redis.conf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/redis-server</string>
          <string>#{etc}/redis.conf</string>
          <string>--daemonize no</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/redis.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/redis.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    system bin/"redis-server", "--test-memory", "2"
    %w[run db/redis log].each { |p| assert_predicate var/p, :exist?, "#{var/p} doesn't exist!" }
  end
end
