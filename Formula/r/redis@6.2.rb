class RedisAT62 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-6.2.14.tar.gz"
  sha256 "34e74856cbd66fdb3a684fb349d93961d8c7aa668b06f81fd93ff267d09bc277"
  license "BSD-3-Clause"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(6\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "490de5da0159c8f9bbca63d8197fd4dfa84ee00d6bd6d9c2db30f101b26199c6"
    sha256 cellar: :any,                 arm64_ventura:  "660d4d10da10417b93f151fdf275071703486ba0cda4fc383850eeddfd338916"
    sha256 cellar: :any,                 arm64_monterey: "1baaf744178c1f676f12c5d1ec57ec0a1a0bda9cdb67a0b52b4dd8497c417ce8"
    sha256 cellar: :any,                 sonoma:         "a50745638f337dce51e148a1d6cf053d4e891d4dfe45886256908c0bbb22be34"
    sha256 cellar: :any,                 ventura:        "d60b0fd9f914206ba80d3f23c0a203054999b42f0c5bc088ecbd5c6cab82dbd6"
    sha256 cellar: :any,                 monterey:       "efe3813770c6148cfd5c552106ac9b799d07e9c4b2223dfdf0fc5d6a9f756353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c70f66eefc29797406f92f2ec1096b66a34e229ce600e936388b0dd957999f37"
  end

  keg_only :versioned_formula

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
