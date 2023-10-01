class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-7.2.1.tar.gz"
  sha256 "5c76d990a1b1c5f949bcd1eed90d0c8a4f70369bdbdcb40288c561ddf88967a4"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1f8bc92ee86e652c307f4cb242fd1c20e852b57655bd675a2c4d4e6eeb6ce9aa"
    sha256 cellar: :any,                 arm64_monterey: "3b5fd4f19340f608800faefbdec54141139ffbab0c1f5f9e28ac6540a6f92e0f"
    sha256 cellar: :any,                 arm64_big_sur:  "7399b07530ec8ecf674b6d1e3bec31c1f46374a9f545982ea27953c654659988"
    sha256 cellar: :any,                 sonoma:         "3b37dd962054703ce81d9fb204257642181b34b9c26829b3f44bfc735dd4e536"
    sha256 cellar: :any,                 ventura:        "1004403807ad5b66a43e9378f4d16d258ec0ee4f54d68ccc5a44f1f8b1bf1b6f"
    sha256 cellar: :any,                 monterey:       "697cd84b21cf855dec8e583ea46ce723ed139ce68d9f8ef90642437956de5ffd"
    sha256 cellar: :any,                 big_sur:        "d5d3966e8d18f3d610ce87037c0832a492278e7bb39d23db4b09a8031e767201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca0d71336e4db1c285f3333679afea03e05f2587cf3feaaff57f0db6a751aecb"
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
