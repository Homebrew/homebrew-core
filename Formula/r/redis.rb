class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.6.0.tar.gz"
  sha256 "d7e5f65f0bb0b4753d0cf98a60f5409a7c9b430ff8ac3397d336260cf64e5a6e"
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
    sha256 cellar: :any,                 arm64_tahoe:   "56eba1a890af40f2eae790c0ebf7009ef269e9b5fb7be30e42c6c5b2336bfd69"
    sha256 cellar: :any,                 arm64_sequoia: "759d2d664d9873b15453e97fd415221f74e43b25925eec93b7de3ac3233053fb"
    sha256 cellar: :any,                 arm64_sonoma:  "3819d9535abcd165e363129542219439623b0103e2f6ca873562479c70208dc2"
    sha256 cellar: :any,                 sonoma:        "642c207ee4e2970ff8aaea36f639902285fa3c9acde34c11f9c2c2c54453618a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68c3a478b2046d7b4986a7b1f6ed6ba7f79fb3d7ff1ffb2c09c2f5bddd468cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d80fe07baae151a343a1734af4d8905ec5e2912582948cbc256eaa9a91a6f59"
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
