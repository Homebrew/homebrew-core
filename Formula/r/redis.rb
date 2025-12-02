class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.4.0.tar.gz"
  sha256 "ca909aa15252f2ecb3a048cd086469827d636bf8334f50bb94d03fba4bfc56e8"
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
    sha256 cellar: :any,                 arm64_tahoe:   "9c8066d1449fe4409ceac586524fabe20ffbc5d0550dd51c6854cd44fb36dc18"
    sha256 cellar: :any,                 arm64_sequoia: "47545c5a6b4111af674b84fb0ea731451a77c43ab7d14b30202c7952d56f455f"
    sha256 cellar: :any,                 arm64_sonoma:  "da7ab72d1d8f23e7d4faf24c8819128eb209ca613d5baf7d5b093385e4051081"
    sha256 cellar: :any,                 sonoma:        "4741855b02343ac4c68bde8aee23e6865cbdeb5ba2d16c67b46b991db06adc03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcc94d4c8530780cd3cb0f4bda5952d3ce97c088a970ab561c114eeaf06b1efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e8351a1d086b3a541b28fff6ae7aad46033045fd9440a707d10b972e1bbc41f"
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
