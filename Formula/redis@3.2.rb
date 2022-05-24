class RedisAT32 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-3.2.13.tar.gz"
  sha256 "862979c9853fdb1d275d9eb9077f34621596fec1843e3e7f2e2f09ce09a387ba"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, monterey:     "deb6e587553223765a595738749c519e42c28c846bed77c1cdb5616ddc0a7b4e"
    sha256 cellar: :any_skip_relocation, big_sur:      "ebf02c105c998bee699b3cdd3a22f123d45b731303f579cc5c4eebb8d31cd4f1"
    sha256 cellar: :any_skip_relocation, catalina:     "ab55e1c85d04427647265baa073ca34e994ce5e6199efc2d4ba9e9c9cb6699f5"
    sha256 cellar: :any_skip_relocation, mojave:       "6437dda1d4ea2fa65609fa585a44cdf1a26e218ef35b3c47c80b6e2850b36d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "139eac3e368bd84fd77338816503733351918b8ac044e60fba7dcda26eb3cbdc"
  end

  keg_only :versioned_formula

  deprecate! date: "2020-04-30", because: :versioned_formula

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", var/"run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.gsub! "\# bind 127.0.0.1", "bind 127.0.0.1"
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
  end

  service do
    run [opt_bin/"redis-server", etc/"redis.conf", "--daemonize no"]
    keep_alive true
    working_dir var
    log_path var/"log/redis.log"
    error_log_path var/"log/redis.log"
  end

  test do
    system bin/"redis-server", "--test-memory", "2"
    %w[run db/redis log].each { |p| assert_predicate var/p, :exist?, "#{var/p} doesn't exist!" }
  end
end
