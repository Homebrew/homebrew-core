class RedisAT82 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.2.5.tar.gz"
  sha256 "68de6b8c7665ac7f5ddea026745515ea027a1e233d3ed413f67134333c0e611b"
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
    sha256 cellar: :any,                 arm64_tahoe:   "98dc91477160c0076ecf6f93f3ff2a7d03738838fb4e27aecebed92ce3e91859"
    sha256 cellar: :any,                 arm64_sequoia: "152bc3912ec0ea39058032fd6315ef6a87c03077276102a997d72d2a1380392b"
    sha256 cellar: :any,                 arm64_sonoma:  "20c76d7eafbb04762e8c405220786ff87dea7f3f84c5edee7828e942e2da2f8a"
    sha256 cellar: :any,                 sonoma:        "3038cf858b7ddb8ce320e5ee8acec1e63c789539765575670d4c26a460061679"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b613fe46b6da065b5c5b3bee18d5f3597197d12c91d39a7d7a067eb1ca5bf715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "752002b1aa5a779970903a2849d29d4e16bc205db89b107d45adf8400d3e77a5"
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
