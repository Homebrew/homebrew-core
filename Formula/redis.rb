class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "http://download.redis.io/releases/redis-6.0.3.tar.gz"
  sha256 "bca46dce81fe92f7b2de4cf8ae41fbc4b94fbd5674def7f12c87e7f9165cbb3a"
  head "https://github.com/antirez/redis.git", :branch => "unstable"

  bottle do
    cellar :any_skip_relocation
    sha256 "697a7d23ed18368d613ed1ee98e3acff2ee25bf0a467fea7eba2bba2bf318358" => :catalina
    sha256 "c73516ff4a9049dc500901fc6288ddbc8da493fc44a04eebcce6d38aafeae753" => :mojave
    sha256 "fd65764b4e0949911693d4004deae63e8bfe6831cf3f57c9defea2e47f98bbfc" => :high_sierra
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
