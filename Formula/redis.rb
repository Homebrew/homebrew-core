class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-7.0.9.tar.gz"
  sha256 "f77135c2a47c9151d4028bfea3b34470ab4d324d1484f79a84c6f32a3cfb9f65"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "80478a21d16d854f4adf17fa2c175fab29bc758d7b911e87851ffac2e612fe2d"
    sha256 cellar: :any,                 arm64_monterey: "53c03c7313d1c383d877df7d495c5d386bc6b4f92151e4a81e965ed24c7f4268"
    sha256 cellar: :any,                 arm64_big_sur:  "850f57a570d21cff0cbde62763e691a35292ea99de2ee82bb9113bbc9f71bf9f"
    sha256 cellar: :any,                 ventura:        "9ae0658fce2ccfd97dbe26cd118f27757de69ba2abc0a257961c10c3462efedc"
    sha256 cellar: :any,                 monterey:       "cee17ef71ca7c0196b7765b6d77bd33df984272cf02e2db463f4a773e3e14d59"
    sha256 cellar: :any,                 big_sur:        "21c0e6c0a72a6bbf8067142def31e0098c7f964f8ffd376ce8d9d6ead0ea899b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7c191b203083263bf160fb5e5645cc75d2f68779f3346a98eedbb78e0eaad3f"
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
