class RedisAT82 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.2.6.tar.gz"
  sha256 "78dd7326c5c959202c6c3849d3ea9c61896d78d647c20f6542b52c0917f96eac"
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
    sha256 cellar: :any,                 arm64_tahoe:   "e7877125678bd2a162f149b99b9d1c886d503306502b1e293876a5fd48e7dc5c"
    sha256 cellar: :any,                 arm64_sequoia: "0cea7611a724953ce034ea43aacc1b62d62730d90b34f91e12f16cc978da406b"
    sha256 cellar: :any,                 arm64_sonoma:  "a4ebcad9e75c6a6aa8a2b149e8595fd399f9b5c8fcf02327e81784939c8719af"
    sha256 cellar: :any,                 sonoma:        "a5d5968614ca6a325602f0c93e712bfc4a3d37f94c819fc51a3b16947a3aba75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6df2454501458067779354e4ce2e1aaba0d94ea27ca7413fea89ee75e88f4d26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "310ca6b5d8f4f241432e3dc89252671ab523f8258e083bbf62d9b23f75d0390d"
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
