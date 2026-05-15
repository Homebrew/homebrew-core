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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "cd4eb1b96b016ccd7523220dfbb54d2ec43a6353f1d5e6a37b69a3d5826b862d"
    sha256 cellar: :any,                 arm64_sequoia: "ba77d3318b97296371305f5d86483f6df37a53eadb6cefaa376e978cd0ba60ab"
    sha256 cellar: :any,                 arm64_sonoma:  "9232f49d3f05f9d29f7b2f249f321fbea058f9b1dc975911b8feb93b08f70483"
    sha256 cellar: :any,                 sonoma:        "d0c41543bd1793e73ce558c9a562d038afe9c9fb73e2e0648a867e29d66225ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "124f3979fad86b60148a68312f19a3c5d86f392e76419dcb34d1ea28fa5b77f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0049cf89efab45893c62e3ef076c19dece57d7b25d3b0ca1679b4af2a6c5cfd"
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
