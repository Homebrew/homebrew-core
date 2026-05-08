class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.6.3.tar.gz"
  sha256 "9f54d4458c52be5472cdd1347d737f1d488b520fc3d0911cba47302de8d836e2"
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
    sha256 cellar: :any,                 arm64_tahoe:   "69857547948e7ca8f6324ec169a9d14acccd0d892be8a850e7b4015052f216de"
    sha256 cellar: :any,                 arm64_sequoia: "a08f94c910880ef852e95c4fbefa30371c3e765e66f6cd76c196b86166bf145a"
    sha256 cellar: :any,                 arm64_sonoma:  "89ce05fd284686569e992c1d31337aa36686f2ae8e1986076c34e7957d2b5261"
    sha256 cellar: :any,                 sonoma:        "b84b11b36d00d866b6449f894df3f7dedccc2c274936cd1e5d8e4cc2e9167262"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c02ead2d7544babd9dd9c29728ce8a3be6af6ddd1c1693f4fd33a588f837e7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef817043bed2c5cd27463aa30f6a0e130232891e14527433dddead55366bad60"
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
