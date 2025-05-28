class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.0.2.tar.gz"
  sha256 "e9296b67b54c91befbcca046d67071c780a1f7c9f9e1ae5ed94773c3bb9b542f"
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
    sha256 cellar: :any,                 arm64_sequoia: "d53e4244ae3ee2f4d6c1642aa1602d3bdd1a6d1d68fd8d588da0a78a8788a4ce"
    sha256 cellar: :any,                 arm64_sonoma:  "688203be10f59797b3c6a8dcf4a538b88b60b7702b93eeff9b584657a46212f4"
    sha256 cellar: :any,                 arm64_ventura: "532d5bd5a388b5c75a0a127d41f58711c0bbd0e74c294cf3c968f8b2ad69d2e1"
    sha256 cellar: :any,                 sonoma:        "36fdb69dc75fd6449815349d5543bb3e129e80a72afc6c32be5f8345e32c0028"
    sha256 cellar: :any,                 ventura:       "61766b32e1720a5d8f97a755e1ef8d99bbf3fa586172fbc0bcfa347e7548dbc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19dc64db8d98fbdecd21ea028a9bc4099d7ee25bfb71e2848273a56f14b6624c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4d15db28e87c238c3ebc39b43d0a7bcd2785bf4e41b4f1a864a047830ed8468"
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
