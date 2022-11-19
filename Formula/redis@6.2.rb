class RedisAT62 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-6.2.7.tar.gz"
  sha256 "b7a79cc3b46d3c6eb52fa37dde34a4a60824079ebdfb3abfbbfa035947c55319"
  license "BSD-3-Clause"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(6\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "23a1e87fc9c0c3c5c305080f60dbaa02227dd3c122251d51735dfdf00e3c9ef6"
    sha256 cellar: :any,                 arm64_monterey: "1b7d170b8da5d389e3d9445d922c7041690b13072981e275b1ed33db654d9fa3"
    sha256 cellar: :any,                 arm64_big_sur:  "759bf94a0731dd0138a8ab946694b74dd59997d06026b1f662231d5da545fe96"
    sha256 cellar: :any,                 ventura:        "04a9ee28725da3a7f3e01a71a3fc2f721445c4f6a6436bf0fdc846b6ac37b2e6"
    sha256 cellar: :any,                 monterey:       "13c5b091fbcd6f9d9c5e3e7a89a57a38db08d9d47b2340d236ba7c71c43fa867"
    sha256 cellar: :any,                 big_sur:        "2d8b4db3e009882e7f3193bafd665fbad0e2854eba62a2faf242e8bfa7a89b8c"
    sha256 cellar: :any,                 catalina:       "45405f6326db4660fa95f046bc65ae7a27e81f67fa445608799c8b8d66ce5383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14007b1e013e245433e328017c78d5811b9740c5213044a44ec59acc8a3f18bc"
  end

  keg_only :versioned_formula

  disable! date: "2023-05-27", because: :deprecated_upstream

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
