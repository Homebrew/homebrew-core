class RedisAT82 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.2.9.tar.gz"
  sha256 "531b314e5557ad76d941f605b3e3162ac61dc141f37c407e1f91fcfe17ea8c30"
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
    sha256 cellar: :any, arm64_tahoe:   "210951f59275d7beb5f1697b35d1677cb29519effe51813bcb8f111431537105"
    sha256 cellar: :any, arm64_sequoia: "00506c8b1caa7168e12e5e87d9b3dc7cdbd4d169ea08bcb88f8e1713f70eb71e"
    sha256 cellar: :any, arm64_sonoma:  "9527220a9af9da8c7a88e18e4da613fd6cad73e4ce794d7f422b34e258337e1f"
    sha256 cellar: :any, sonoma:        "401347ec5d5ab33aa6294c6e17c719e28463e76d0c85c483c283bf8bd0131eb3"
    sha256 cellar: :any, arm64_linux:   "32bc791db8dfb13b87a2c733d0a53119a454810b54210dfde09e17a4116331a6"
    sha256 cellar: :any, x86_64_linux:  "40bbc0d54994b1375113efb6620431b2abd65df850e5bafd0596df396e638cd7"
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
