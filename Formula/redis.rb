class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-7.0.8.tar.gz"
  sha256 "06a339e491306783dcf55b97f15a5dbcbdc01ccbde6dc23027c475cab735e914"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ae86b7febe606ccae0aa8ffaa993610862d5e33ad3ac506575b6d9bcc635addd"
    sha256 cellar: :any,                 arm64_monterey: "a1da26d419ac2337b312bf922348f1fabd3678906982dafc8640db8de912f558"
    sha256 cellar: :any,                 arm64_big_sur:  "5b1a0cc4a506bf841210478887cf64a1e0db3b25907f000f7d31b694be997413"
    sha256 cellar: :any,                 ventura:        "bd8f38b99ca93cbcc738a9e50dcf1c43a872b0693268609bb7f6dbff97d11f54"
    sha256 cellar: :any,                 monterey:       "c789c9fe489acd0d1d44e213b4a36be0c4e37417194a1e12d5ca9048137a7b2d"
    sha256 cellar: :any,                 big_sur:        "2c41b7dc7d3fc69bb4fa66e98617a72ba2b9ccfb0a7f0fa5057bf065b299e180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28037c9f3a8af1671d6e6ea9118cf933c10acfee2e7831b1528d7f9d1274538b"
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
