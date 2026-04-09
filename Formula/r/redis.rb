class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.6.2.tar.gz"
  sha256 "cea46526594fe05f05b9ff733179eb1263deccf4269059cf081fdef222634c88"
  license all_of: [
    "AGPL-3.0-only",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  compatibility_version 1
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd5fafe58c19aa8f171d06ec58f7233eeefe3178c4f373401e37f476d2b3cd92"
    sha256 cellar: :any,                 arm64_sequoia: "d726a846bff4f74cac045f84d9151f515b7733ff23bf2c28c5ffcbe018c7916b"
    sha256 cellar: :any,                 arm64_sonoma:  "c970f0d89c6664ec9c6929337a7c6a94ad311609d02945052f185ad28c883798"
    sha256 cellar: :any,                 sonoma:        "954968cfbc5e3fcef534b7cd3fe4bf796b209a49e5d2c2ff37e2e9f892f3ebaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03295922ca2029d5164cdcd9906b6e2254649e3a6b2b6a4593ec219ef3e2a71b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eef19f0db6a73cfe21402002d42a96ba43de20f9ad2548ea8a7fdd53b8f5ccb"
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
