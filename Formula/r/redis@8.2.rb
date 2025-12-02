class RedisAT82 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.2.3.tar.gz"
  sha256 "d88f2361fdf3a3a8668fe5753e29915566109dca07b4cb036427ea6dc7783671"
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
    sha256 cellar: :any,                 arm64_tahoe:   "7464135edd58367935f8d7b686d9fb010b3029f81fab35cba3158cac6bd11b4c"
    sha256 cellar: :any,                 arm64_sequoia: "3a06ee53e02ebc4337c91d7b01d56b78b1620749a5ae94e377c92725572c2abb"
    sha256 cellar: :any,                 arm64_sonoma:  "4d3f1eef9be56cc5a513c59a06106f80e4b83f780516fc73af3cffd03683e30e"
    sha256 cellar: :any,                 sonoma:        "9b7db68f2122d3d1aeef9345dd70990df55fbd25eb2cb0902f8deca2aebb7944"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecbbcd33b86aceda55d3f3268c4faf0e4279cec8baad978b9605e2ce961c7eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c44ea9d0b00581d0d82fa8b2a138f8dead742fa456fc27a3724ccff427fc45e"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"

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
