class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-6.2.6.tar.gz"
  sha256 "5b2b8b7a50111ef395bf1c1d5be11e6e167ac018125055daa8b5c2317ae131ab"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a656500c3b5762c7cfe03d587a4fa08c5df4568783d167555962d850e8cab3c3"
    sha256 cellar: :any,                 arm64_big_sur:  "846aada68ca07b36d58fd620ed5d52ae67a759526c5da27042748363bfdb6271"
    sha256 cellar: :any,                 monterey:       "ac30519a604ff014e3903893ddca6c563c134002fec58df3613632e42c4d117c"
    sha256 cellar: :any,                 big_sur:        "246f73498993a2a0c6c4326a298d2fcc3da6d61904ad09a631aa9c63a6800f76"
    sha256 cellar: :any,                 catalina:       "ff93a763d622cc9130c09fa9ce2ec7236f91562667eaa5c304fcf175c1253746"
    sha256 cellar: :any,                 mojave:         "57842762aad1434f8b511f603364b4528f0545f7d768c9387b362011351cda2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8398fc05ef8eb1ea3d7b26844e3a314a948b3d0d4fb937a00c6c62f0abbe340a"
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
