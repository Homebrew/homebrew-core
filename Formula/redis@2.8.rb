class RedisAT28 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "http://download.redis.io/releases/redis-2.8.24.tar.gz"
  sha256 "6c86ca5291ca7f4e37d9c90511eed67beb6649befe57e2e26307f74adb8630fe"
  head "https://github.com/antirez/redis.git", :branch => "2.8"

  bottle do
    cellar :any_skip_relocation
    sha256 "8bc74d2a2fcb58aefa509bebf86bb23869e56b57174724bba41e0bf622c38427" => :high_sierra
    sha256 "1d18d6126e99fa6bf7f3ec85b64d0d16ee0609605e6f4c33cb588e2309004d93" => :sierra
    sha256 "d2a1b2b949acd8c7b1fb81a410c186c685889a72941b9b12307bfc991bb6e178" => :el_capitan
    sha256 "4378693db47ae69e391cf22a212622cecc498702589ffe42e24eaac3ada58072" => :yosemite
  end

  keg_only :versioned_formula

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = MacOS.prefer_64_bit? ? "-arch x86_64" : "-arch i386"

    # Head and stable have different code layouts
    src = (buildpath/"src/Makefile").exist? ? buildpath/"src" : buildpath
    system "make", "-C", src, "CC=#{ENV.cc}"

    %w[benchmark cli server check-dump check-aof sentinel].each { |p| bin.install src/"redis-#{p}" => "redis28-#{p}" }
    %w[run db/redis28 log].each { |p| (var+p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", "#{var}/run/redis-2.8.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis28/"
      s.gsub! "\# bind 127.0.0.1", "bind 127.0.0.1"
    end

    etc.install "redis.conf" => "redis28.conf" unless (etc/"redis28.conf").exist?
    etc.install "sentinel.conf" => "redis28-sentinel.conf" unless (etc/"redis28-sentinel.conf").exist?
  end

  plist_options :manual => "redis28-server #{HOMEBREW_PREFIX}/etc/redis28.conf"

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
          <string>#{opt_prefix}/bin/redis28-server</string>
          <string>#{etc}/redis28.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/redis28.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/redis28.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    # This previously wasn't bottled. Make sure it is.
    assert_predicate HOMEBREW_PREFIX/"etc/redis28.conf", :exist?

    system "#{bin}/redis28-server", "--version"
  end
end
