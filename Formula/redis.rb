class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-7.0.11.tar.gz"
  sha256 "ce250d1fba042c613de38a15d40889b78f7cb6d5461a27e35017ba39b07221e3"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e1f9daea7221b9e6cf8e728091768d48dad76c9eba895dcef7b23346682f1958"
    sha256 cellar: :any,                 arm64_monterey: "147a61d803cf58b1c7487a9d6e55527d95b1dbe7c1b1c209d8620ae5fcd844a6"
    sha256 cellar: :any,                 arm64_big_sur:  "6361bc1693f1001576201a6297da2af66f128a6f14dd5f76798fb02d4fbbbb89"
    sha256 cellar: :any,                 ventura:        "cc44b00cf2c241f0e13f59932dc1c223b5b597d8235b7e225c25fce4488b7fce"
    sha256 cellar: :any,                 monterey:       "75b61d43ae1fda800a66bf901d3bd3bcacd6fecb0b29b3ae73662a4a5d46f959"
    sha256 cellar: :any,                 big_sur:        "e0636286f7d4a8975ae68aedfe6c44e28aaff66ae4886558388edc162e031a40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd959690bdaa25ca6fe66e6e1150f5ffa981408c025812743c217016bdcf341e"
  end

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
