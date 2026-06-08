class RedisAT82 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.2.7.tar.gz"
  sha256 "afaae66030c193b06720a714ba7a558136b82689027536e0e24f53908c18cbe9"
  license all_of: [
    "AGPL-3.0-only",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(8\.2(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1cf6390113cbcd2bad484da8025b3abe64db922fa840c68ae4fb8a0d1cf9fa61"
    sha256 cellar: :any, arm64_sequoia: "dd942b85f5553aaa5b894d92f2acb44feb13d2fa0f806d800152569aa6d9efb6"
    sha256 cellar: :any, arm64_sonoma:  "cf29b2b5231531b39336ec1c917c778ee9863323540c2dc662a813427cd9e7ad"
    sha256 cellar: :any, sonoma:        "cde7db2925582ccbc86ecdc75ba573914fe260e28df69112400c905dcfde55f0"
    sha256 cellar: :any, arm64_linux:   "672034d1a8f096756cdee2fb28bc06f12a5d2beb0f2c1b116950b5d42cf51a10"
    sha256 cellar: :any, x86_64_linux:  "bc2a27bb2d5646feefb088e73426225eef200cbf78da21bc621b0358ac01e003"
  end

  keg_only :versioned_formula

  depends_on "openssl@4"

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis_6379.pid", var/"run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.sub!(/^bind .*$/, "bind 127.0.0.1 ::1")
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
  end

  service do
    run [opt_bin/"redis-server", etc/"redis.conf"]
    keep_alive true
    error_log_path var/"log/redis.log"
    log_path var/"log/redis.log"
    working_dir var
  end

  test do
    system bin/"redis-server", "--test-memory", "2"
    %w[run db/redis log].each { |p| assert_path_exists var/p, "#{var/p} doesn't exist!" }
  end
end
