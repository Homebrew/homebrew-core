class RedisAT40 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://github.com/antirez/redis/archive/4.0.14.tar.gz"
  sha256 "3b8c6ea4c9db944fe6ec427c1b11d912ca6c5c5e17ee4cfaea98bbda90724752"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e9a2c7da7676cca21b9ece9ccdb8576d17060d7aa5e6829127407b4629f22e3" => :catalina
    sha256 "afe26b0f773f004d2bb0a5fa60970d6f9143fe7aab0d604a2e2e453fbdf70d3f" => :mojave
    sha256 "0fa9ceef9985e487714b8ec356c45d77ac1856e99d8a87cef405439ef4939cde" => :high_sierra
    sha256 "537fe6969d900f34df0e072e7f90e43ca85c665f95952b7dea196691e3955592" => :sierra
  end

  keg_only :versioned_formula

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

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/redis@4.0/bin/redis-server #{HOMEBREW_PREFIX}/etc/redis.conf"

  def plist
    <<~EOS
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
