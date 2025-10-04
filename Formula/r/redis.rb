class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.2.2.tar.gz"
  sha256 "4e340e8e822a82114b6fb0f7ca581b749fa876e31e36e9fbcb75416bec9d0608"
  license all_of: [
    "AGPL-3.0-only",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "625a4e2a403cc4b748f743beacfdf74e8339cbe149b78025698dd2ff8dd8ead8"
    sha256 cellar: :any,                 arm64_sequoia: "a8594939b4b069d236aa7ff196f7338771baa3c0c232e9ab2880fe91a30dfd12"
    sha256 cellar: :any,                 arm64_sonoma:  "7d4c41aabbb04b15b86cdcc21a13c34e6ba1004f991f260d0fa3d322a949638c"
    sha256 cellar: :any,                 sonoma:        "0fae76c2f9e0a999bc805b9a7b45d7edc7cf985efaac61912fd16b3221ba09ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed5f0084d40f69cf31b9b202b74d9c265c3f2244c588feecfc19dd9f940a5d34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e1a701f75b6b7dccaae50707284f341c5f2611dab7d560c0706650cfb7b67a0"
  end

  depends_on "openssl@3"

  conflicts_with "valkey", because: "both install `redis-*` binaries"

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
