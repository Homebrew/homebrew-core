class RedisAT32 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "http://download.redis.io/releases/redis-3.2.13.tar.gz"
  sha256 "862979c9853fdb1d275d9eb9077f34621596fec1843e3e7f2e2f09ce09a387ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c733f90aa40d633ae75fa3e8deff1610de771c5ac145217fa083c4eaf5ab73f" => :catalina
    sha256 "fd4bab827397fe1f84add898e38a2d12e3fd0b51027a4c84b89957cebce4ed37" => :mojave
    sha256 "480fac35b3024d2ab0a77ace18b56f70ff1e7f34e11570dbdd4fcf8bc00927cd" => :high_sierra
    sha256 "7d820929a7f4c0e2c7d7a7a5dadfc549ed4df306ef89f6e80c65148b8bb21504" => :sierra
  end

  keg_only :versioned_formula

  deprecate!

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = "-arch #{MacOS.preferred_arch}"

    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", var/"run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.gsub! "\# bind 127.0.0.1", "bind 127.0.0.1"
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/redis@3.2/bin/redis-server #{HOMEBREW_PREFIX}/etc/redis.conf"

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
