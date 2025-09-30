class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.2.1.tar.gz"
  sha256 "e2c1cb9dd4180a35b943b85dfc7dcdd42566cdbceca37d0d0b14c21731582d3e"
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
    sha256 cellar: :any,                 arm64_tahoe:   "2989dbda2c16049cca031d517dbe4b7806e09d8810ba283951f373a6492f429c"
    sha256 cellar: :any,                 arm64_sequoia: "f1e1c87259f87e2687416db62712f81a3f8880e6cec89f6ea7c517ae791d686a"
    sha256 cellar: :any,                 arm64_sonoma:  "8d473c7658c825d7e97a99c739dfbdd722ae929b300406c66dfb87b3e759b397"
    sha256 cellar: :any,                 arm64_ventura: "97c7c21a13227b52c5634809c2a4ae6f1acde764367277cc20d3dfc9ab4a37ea"
    sha256 cellar: :any,                 sonoma:        "f7c99d1a541a17cc8c6d375f09d1499ae943ceb7d057bb53c1ff473de5cdb9e8"
    sha256 cellar: :any,                 ventura:       "d2fdc1571a609a3866aa45e15e9c051e685d4d90dfcef3ce88d8a8d36c177162"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4310ab011e8cd0a214249a76197420a4575b59eb76046700c921f0122b520817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a853f7a6abc85519d6c07180633b9399466a81b2e4e1eed77fb72ba265db44b"
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
