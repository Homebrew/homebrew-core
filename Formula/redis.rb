class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "http://redis.io/"
  url "http://download.redis.io/releases/redis-3.2.3.tar.gz"
  sha256 "674e9c38472e96491b7d4f7b42c38b71b5acbca945856e209cb428fbc6135f15"
  head "https://github.com/antirez/redis.git", :branch => "unstable"

  bottle do
    cellar :any_skip_relocation
    sha256 "24cc251b428679a5786e9ffd7a225e93bf35679fdf5dc6be479600ea3229bfde" => :sierra
    sha256 "aa9597cf1c64ad6e29611cb7308a8087de29e629bdaa7694493cc24603001cab" => :el_capitan
    sha256 "6128c1cdd1b70bd8353f38d563a5b408cf34f15250c80cec02209f48ef6571d2" => :yosemite
    sha256 "745783c971c50f087bd29c1d48fdc2656c9a9a05182b6abc3342f0ef8218049e" => :mavericks
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
