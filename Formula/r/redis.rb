class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-7.2.0.tar.gz"
  sha256 "8b12e242647635b419a0e1833eda02b65bf64e39eb9e509d9db4888fb3124943"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0a32e5294d7642be65b7689407e396f3d94551db91dc8eefa938e064b515633"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf51bb6fdc6d9216342f0c4535f9bd8d93b209636bebe2f084e21c18f7f502a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3eebc0b5ec9d6258e71572302f6ab7709f8b23eb5478308cbbb27e8a0aa36e2"
    sha256 cellar: :any_skip_relocation, ventura:        "44213e6b3a631c81dc353765b9e6b5b2d29337375233d3238e35244ab15b387e"
    sha256 cellar: :any_skip_relocation, monterey:       "b14bd0a0594e9999e0f365d96ea20e8ed972a9161b4e6d67c9c2a28a994905e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "84f4ce12fb9d27b70c71d7eef7b32143fdfd1cdb275ec431f952ca57eb8109a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c14da3d835526b61ffec4ae8a0ec7460a1247e4b0f8e3a5009f0449c282812e"
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
