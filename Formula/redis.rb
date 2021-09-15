class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-6.2.5.tar.gz"
  sha256 "4b9a75709a1b74b3785e20a6c158cab94cf52298aa381eea947a678a60d551ae"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "080c05259d4b1d5b5a7fe9948b52271a3980c667e1d6fb3b09a31dbe781a036a"
    sha256 cellar: :any,                 big_sur:       "fc47114ec01104559f63cd697eb25117ee37da92a5876a104c0d444a801e54f5"
    sha256 cellar: :any,                 catalina:      "9f060dc1babfe353eb9fc6eae51f3d7440cb61db118b570d8beb36db76b9d781"
    sha256 cellar: :any,                 mojave:        "6632ef23438714fd7b5ac1a3e26cc46aef45c572ea535b3a8ef204cbc2a939e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b0ef13645b8ac6d613623d86c726e7a5cdb023bbde5c7e841dca587527ee506"
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
