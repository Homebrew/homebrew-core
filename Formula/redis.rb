class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "http://download.redis.io/releases/redis-4.0.8.tar.gz"
  sha256 "ff0c38b8c156319249fec61e5018cf5b5fe63a65b61690bec798f4c998c232ad"
  head "https://github.com/antirez/redis.git", :branch => "unstable"

  bottle do
    cellar :any_skip_relocation
    sha256 "90d7dc8b6879ed4d7a6d02b728f5c302659bc42e748630ee21a08edafab11e90" => :high_sierra
    sha256 "0a89e3a6014b20d6632c64f9afe52f4b7c50a1cdb01ff67cc77dda984f000cf2" => :sierra
    sha256 "776db1119e80220ba7438562f87141aad3f3a1b9ff7c7399ce4ad34dbf4b4dd6" => :el_capitan
  end

  option "with-jemalloc", "Select jemalloc as memory allocator when building Redis"

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = "-arch #{MacOS.preferred_arch}"

    args = %W[
      PREFIX=#{prefix}
      CC=#{ENV.cc}
    ]
    args << "MALLOC=jemalloc" if build.with? "jemalloc"
    system "make", "install", *args

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
