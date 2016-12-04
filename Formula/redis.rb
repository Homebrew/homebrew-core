class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "http://redis.io/"
  url "http://download.redis.io/releases/redis-3.2.5.tar.gz"
  sha256 "8509ceb1efd849d6b2346a72a8e926b5a4f6ed3cc7c3cd8d9f36b2e9ba085315"
  head "https://github.com/antirez/redis.git", :branch => "unstable"

  bottle do
    cellar :any_skip_relocation
    sha256 "4530974aa0e3975ec649c1045d0f12181e95029f9dd1819242b91c8e75bf4a29" => :sierra
    sha256 "9954837a3ee4d5879a05eb09ef96b97241d9fbc146f4b9fd075cdbc500c0c887" => :el_capitan
    sha256 "ae6259f91c05dccc4ee4533f2c66f8872d0ffd15fefa9820707bd755dc902f11" => :yosemite
  end

  devel do
    url "https://github.com/antirez/redis/archive/4.0-rc1.tar.gz"
    sha256 "4a7f8daafd5ca6d65a077d0bb8d4b6cc4ba5a2e6da2281fd45acebd327db941c"
    version "4.0RC1"
  end

  option "with-jemalloc", "Select jemalloc as memory allocator when building Redis"

  fails_with :llvm do
    build 2334
    cause <<-EOS.undent
      Fails with "reference out of range from _linenoise"
    EOS
  end

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
      s.gsub! "\# bind 127.0.0.1", "bind 127.0.0.1"
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
  end

  plist_options :manual => "redis-server #{HOMEBREW_PREFIX}/etc/redis.conf"

  def plist; <<-EOS.undent
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
  end
end
