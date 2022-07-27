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
    sha256 cellar: :any,                 arm64_monterey: "4cc1d45e351961e95e782e66c00661316f22d580826f1703c2c59907c83e1dba"
    sha256 cellar: :any,                 arm64_big_sur:  "69d4b633d35eac570aba6c16aacb3e597c16c1f02a5c730c1785ae4dbad3b0a2"
    sha256 cellar: :any,                 monterey:       "b0ceaa7592468ee103656390217caa61259a0542c3289d413e442b6237d25fe5"
    sha256 cellar: :any,                 big_sur:        "28bc30760d01dac125aea13c2c3814995728d63025be4df8e92aefe2bdd6fe71"
    sha256 cellar: :any,                 catalina:       "3387ab3983d8c93d0f57d8796dcc00db3750184c9bdbb1374e468be172de07f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "823b2c71e5656342095f1af7bcb4d43eef9014717b3687a2e6248a7516872970"
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
