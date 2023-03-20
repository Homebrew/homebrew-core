class RedisAT62 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-6.2.11.tar.gz"
  sha256 "8c75fb9cdd01849e92c23f30cb7fe205ea0032a38d11d46af191014e9acc3098"
  license "BSD-3-Clause"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(6\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "16d82095740c2e31fb645a70912f56922fee7a5559f19bf5588419642ab2291b"
    sha256 cellar: :any,                 arm64_monterey: "bca817b5556c6c759f9269f2188e2aa7637c16c1708c6ecb8e3d440cc56e66cd"
    sha256 cellar: :any,                 arm64_big_sur:  "b35fb3dcb2cd55345e786335c35ae3828613e940f9a710e2e61a6bca3c0b0411"
    sha256 cellar: :any,                 ventura:        "f504ad5080c0bb756d7246be1ece7f1f4eafc6c8012edb30a9e61d0b7ba93ff2"
    sha256 cellar: :any,                 monterey:       "4af50bd00bac93fb14e243273a3b8b4da1eab946851a0dbe28ee0c97a6256744"
    sha256 cellar: :any,                 big_sur:        "d35cd01f1f0dfeee7ac49065ab206514aec56f83ec08b0b9811b6d2906a276c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "977af1a9cd4872549e1b8a5f22561634d4e702021607db5ae0f4c115d8c29c3c"
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
