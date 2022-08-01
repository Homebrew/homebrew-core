class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-7.0.4.tar.gz"
  sha256 "f0e65fda74c44a3dd4fa9d512d4d4d833dd0939c934e946a5c622a630d057f2f"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5fd4a4cdd769fdebc82dc5ea1b06edb2464039b38c09355f29e8e70804eb8477"
    sha256 cellar: :any,                 arm64_big_sur:  "203cea84c495237fad2c5b1e172603da5b9f5655a063972d996b45ff83155f10"
    sha256 cellar: :any,                 monterey:       "58f58d9fe07000a83e54581dd7fbe22747701d84ba78def762ae94b341f41259"
    sha256 cellar: :any,                 big_sur:        "a6aaf522bca22031de5bcaeb39ff41f5f1af977967e94a0dac507d2ed8fe769f"
    sha256 cellar: :any,                 catalina:       "38c669f105a76cccf7567b4ee32dba6972c63daaf7b4c178e1f79988f846684b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc16cc18a0e19a14fdc2e47bf6244690455795d89af8445abdf7df01542e1581"
  end

  depends_on "openssl@1.1"

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
