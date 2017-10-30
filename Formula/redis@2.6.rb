class RedisAT26 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "http://download.redis.io/releases/redis-2.6.17.tar.gz"
  sha256 "5a65b54bb6deef2a8a4fabd7bd6962654a5d35787e68f732f471bbf117f4768e"
  head "https://github.com/antirez/redis.git", :branch => "2.6"

  bottle do
    cellar :any_skip_relocation
    sha256 "0276246f36addab47addbb133f51fd322519cd9d4a0f20c3b4eced68846aa843" => :high_sierra
    sha256 "29e779868a0bfaf2d5fbeb275c12dacbc18c9509ccccfbfb41900053b63431df" => :sierra
    sha256 "43fe747ac54b58150f90763f8e89de3c40f6048d7038c6014ec88b7dfe8a3ab0" => :el_capitan
    sha256 "36e5677bc7fa1cfede9409a571823fc3585fe3e086e7087c98f8b14add5214ce" => :yosemite
  end

  keg_only :versioned_formula

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = MacOS.prefer_64_bit? ? "-arch x86_64" : "-arch i386"

    # Head and stable have different code layouts
    src = (buildpath/"src/Makefile").exist? ? buildpath/"src" : buildpath
    system "make", "-C", src, "CC=#{ENV.cc}"

    %w[benchmark cli server check-dump check-aof].each { |p| bin.install src/"redis-#{p}" }
    %w[run db/redis log].each { |p| (var+p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", "#{var}/run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.gsub! "\# bind 127.0.0.1", "bind 127.0.0.1"
    end

    etc.install "redis.conf" unless (etc/"redis.conf").exist?
  end

  plist_options :manual => "redis-server #{HOMEBREW_PREFIX}/etc/redis.conf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_prefix}/bin/redis-server</string>
          <string>#{etc}/redis.conf</string>
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
    system "#{bin}/redis-server", "--version"
  end
end
