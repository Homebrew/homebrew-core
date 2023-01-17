class RedisAT62 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-6.2.10.tar.gz"
  sha256 "22684f66d272379b91e3e53693918b535e2a6e54b9d14e1cad171658e0eefeca"
  license "BSD-3-Clause"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(6\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bd84a61004010182eae7dd0e6024df9051fc3cd99f1f2cc0c1c91e8d017449a7"
    sha256 cellar: :any,                 arm64_monterey: "d289551a0e58ab0ecfdc62617a45ddbf9b7645d300e0fa3f8566a6baf781cbfa"
    sha256 cellar: :any,                 arm64_big_sur:  "d47a2b29f65a2071fe0f59235e55d79cc9cebbbc99aaa65bf020605b14b84a62"
    sha256 cellar: :any,                 ventura:        "a5fe64b34732950c957f7cf11d28494e43b27bc11a2fe23fdd3183cc83216ce3"
    sha256 cellar: :any,                 monterey:       "f0cd35054786e3af8bc74326c98b16eba207fc369dc30cfce7042541a3138609"
    sha256 cellar: :any,                 big_sur:        "698321edcf17b8b1cdafdaed03c238878180a132f74b33b5641e5d3ed3f4a867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e44409fbcc0bf96dd451bad4793bf910cea382c0c71889bad1b2bf0d42e44ed0"
  end

  keg_only :versioned_formula

  disable! date: "2023-05-27", because: :deprecated_upstream

  depends_on "openssl@3"

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", var/"run/redis.pid"
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
    %w[run db/redis log].each { |p| assert_predicate var/p, :exist?, "#{var/p} doesn't exist!" }
  end
end
