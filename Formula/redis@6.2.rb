class RedisAT62 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-6.2.8.tar.gz"
  sha256 "f91ab24bcb42673cb853292eb5d43c2017d11d659854808ed6a529c97297fdfe"
  license "BSD-3-Clause"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(6\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1e007af14274ea20f7baf10fa5a6556257a8afca7cfd73d6786efa9a3197ea88"
    sha256 cellar: :any,                 arm64_monterey: "db68e0d30b0dcaa41e942868c5524583eb25c84d361111e179de3b05df52049e"
    sha256 cellar: :any,                 arm64_big_sur:  "38a1e7411dd419677433c2f8b1dbe81393dbc38b393e5ac0b8e8334964abbd13"
    sha256 cellar: :any,                 ventura:        "2f4125579bcbd52afe5cb22b7b3e08ec5e117fa73f5a8c6646843588497646a1"
    sha256 cellar: :any,                 monterey:       "22d8099c7abaee9e5e8c6cd68cc2d6fd9c04cf244f0c21cc8e822ad35fcd2ece"
    sha256 cellar: :any,                 big_sur:        "294a34649bfeb67eddd77067bc7e486b93f70d47b707cbe1e53fda02d4dac5c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b50313d87795c0efcad96340ff91dac6d54130e0f97343d15ac16e42a12f1cea"
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
