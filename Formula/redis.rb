class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-7.0.11.tar.gz"
  sha256 "ce250d1fba042c613de38a15d40889b78f7cb6d5461a27e35017ba39b07221e3"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2ee771665ac7828c3dfc6632bb5c0ba3fb8f147a0d5014736a6a980d4b056940"
    sha256 cellar: :any,                 arm64_monterey: "d2972b71501b16174b8afffa1625056dfe5c7775d3065568f25f55260e9ea53e"
    sha256 cellar: :any,                 arm64_big_sur:  "2acd9296c0e29d313155d4b44f5f52ebe1cad602b8cf21d8bb91578f4e780ca2"
    sha256 cellar: :any,                 ventura:        "4b207ed6d0aeed11120ee04869f1261ca792801e39954d4ea124ef60c2275bbc"
    sha256 cellar: :any,                 monterey:       "d31b1b0230a0600aaca17e55bb162100bb49812b6393de22678067994df421b9"
    sha256 cellar: :any,                 big_sur:        "62e51fb4fd26b03a1d9e3241f47515da9c3e7e98114b8bdb06aed4148f9b6b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a54eeb6cfe5062a0ed47568b59b9fe2bcb23b3328389b7d72e8f2fefb960c7d5"
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
