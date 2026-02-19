class RedisAT82 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.2.4.tar.gz"
  sha256 "954943d4873f3add5e3b694832b52753e9f55b810a917d0148675f27480ac8c2"
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
    sha256 cellar: :any,                 arm64_tahoe:   "e030c95c6e94de6b476e60f63d050a7434edc412fb40abcd49a9223ebae1abf7"
    sha256 cellar: :any,                 arm64_sequoia: "787615c8cd23ec00ab5bb2986b7e1a6d813a238cb2e34ebad1149b7a861296d0"
    sha256 cellar: :any,                 arm64_sonoma:  "619a37fe191f683e623ba1bb02096a6df929f6e699e73ce07674a33b78c88842"
    sha256 cellar: :any,                 sonoma:        "ca777a05242c4a860cd7884789b83b61b879b5a398523b5c26a401cacfc6edde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "480cc319600e743d3b6ce317846fda10061b27abcd73f4112050e585f8429141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2071d7be98d4c5f2c84633ff55a7c2f7f35b87f6f0610f1f55ef4f24074604e"
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
