class RedisAT82 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.2.10.tar.gz"
  sha256 "d33935732f7fc15476295fe05f5ce740927bc14847798e47b3f67b4f27b8b478"
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
    sha256 cellar: :any, arm64_golden_gate: "f0d2d0117ea962dcf3180812aa1fd7430581c7867a45a6d3fd43852112bbd6e1"
    sha256 cellar: :any, arm64_tahoe:       "e4ef7119c6e0061ba27aaa7772c03b060932a921fc9e51acce15042da5bfb645"
    sha256 cellar: :any, arm64_sequoia:     "8d2d297a4a056aefca23a8fd1571f902892bf9006e31f83aed8a8a159401779e"
    sha256 cellar: :any, arm64_linux:       "b427dfb3c088e39b466f3f9f840d84a8272df1502b6c2952782d0f27b78884c3"
    sha256 cellar: :any, x86_64_linux:      "4294c200d3a6ce459b0cf58258671b5532854e14e5db31f5f893f0c2294e908a"
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
