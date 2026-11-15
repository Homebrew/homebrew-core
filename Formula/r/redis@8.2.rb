class RedisAT82 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.2.11.tar.gz"
  sha256 "fba14b77c4bdcb2d5418b6741fc0cdaac4b78bc73eab9b2e5f3c255d597f16fa"
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
    sha256 cellar: :any, arm64_golden_gate: "2437f13575a06fe650b06b60f498cd9d6999bf0af3accfebccfb9702c3f97756"
    sha256 cellar: :any, arm64_tahoe:       "259a321b90c0d0bca18a4878ad5429dab239f73064e4354c1daca088674c9181"
    sha256 cellar: :any, arm64_sequoia:     "4879c4e8d1b2be1958672229e9464b8d995d28bcc560ed1f06b18731e8a03d5d"
    sha256 cellar: :any, arm64_linux:       "0e51dc70d858bf576fb0e6336f3148b7cfbceffdbe7662a50df31b026b4e5e71"
    sha256 cellar: :any, x86_64_linux:      "63db52d5338553b9439f481bbf90b66c634296ad65ed29d24e0f9cc0abdab076"
  end

  keg_only :versioned_formula

  depends_on "openssl@4"

  allow_network_access! :test

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
