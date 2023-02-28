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
    sha256 cellar: :any,                 arm64_ventura:  "504489073b3154dbf54ac31b9d1b4849a32595dedf4ea246535e4c366d2410fd"
    sha256 cellar: :any,                 arm64_monterey: "32ca02bb872f05a83fb455cc8e2e85a039ba4cd439ecf11f16269131d1d82da7"
    sha256 cellar: :any,                 arm64_big_sur:  "c6ccb7539b8d8b5ffa2c84e0a57f9340d033be97e6e1b25f4cc587fa216c624c"
    sha256 cellar: :any,                 ventura:        "6ed1f00de9958e23f87766615fe2085b5431de77d46190599fec4e8570bf65c2"
    sha256 cellar: :any,                 monterey:       "86e6bfa62634050824969a04ae1f55a12ee393e6fd63dd429b8f1414a4221bd9"
    sha256 cellar: :any,                 big_sur:        "c4fa215726360ec71b3bd3901d1155c655f00c180051ba7932ae3cdd2b5a24fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c7ab628a9eafd256db997897441658a13c1ae04b6faa449f08e267763374f15"
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
