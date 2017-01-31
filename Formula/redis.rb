class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "http://redis.io/"
  url "http://download.redis.io/releases/redis-3.2.7.tar.gz"
  sha256 "bf9df3e5374bfe7bfc3386380f9df13d94990011504ef07632b3609bb2836fa9"
  head "https://github.com/antirez/redis.git", :branch => "unstable"

  bottle do
    cellar :any_skip_relocation
    sha256 "a819b2ce1b8832efd7540182850fe5d858b8661c8b2595058b75ce14df77d260" => :sierra
    sha256 "8741b9345a84dc4c679f876bbce60f1fdbc925f75ddeba4822ac8b28293ec380" => :el_capitan
    sha256 "7b140a8ecc9eaa94ba756ea7afd08f901884217827dab3fe74df0abad55fabed" => :yosemite
  end

  devel do
    url "https://github.com/antirez/redis/archive/4.0-rc2.tar.gz"
    sha256 "70941c192e6afe441cf2c8d659c39ab955e476030c492179a91dcf3f02f5db67"
    version "4.0RC2"
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
  end
end
