class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.0.0.tar.gz"
  sha256 "cf395665ba5fcecc4ef7aed1d8ab19c268619d98595827565c82344160171262"
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
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fe7717fc1397f4ee553cdb7edf75d6d983cd6ca6a853636b886ee995092a2d5c"
    sha256 cellar: :any,                 arm64_sonoma:  "f01fe3f29eb821198c289eb2908c1d701610c6abb72d312b61ba302cf8a5dbc1"
    sha256 cellar: :any,                 arm64_ventura: "bb912351e1cfc319cd814985ef2749df9991a49bb8c609f6fa8f2a9c88c7720a"
    sha256 cellar: :any,                 sonoma:        "b3f8ff9cec4d228193768415e4f67816f2140967997f2a66b86fb916a5ac3dd7"
    sha256 cellar: :any,                 ventura:       "a0cc960fc453ccc3c2b9a3f1c7f11aaba58634cc32cbf75d10f9d7d561f29df2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87c58efe520b8b8df90e4c43cd1e271b130b5db13593b290d494fc3ac6553678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2825ef1181669c02e0e693ffcd09414d34b2e958ff935c06dda01fd77b4af4d1"
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
