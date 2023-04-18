class RedisAT40 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://github.com/redis/redis/archive/4.0.14.tar.gz"
  sha256 "3b8c6ea4c9db944fe6ec427c1b11d912ca6c5c5e17ee4cfaea98bbda90724752"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, monterey:     "cba692eaa032feec943d96c3a47ce7c2fc72fdc10e81680edf1d8e1703a8cbd2"
    sha256 cellar: :any_skip_relocation, big_sur:      "baedf1761e5966fa4c25e461ad6bad3cc8ec500bc4da9aad6fa98f01d7bf651f"
    sha256 cellar: :any_skip_relocation, catalina:     "59eea40bb4b8f05511f58eef72b3dab1966828bfdb9c776515f1f34d0c140896"
    sha256 cellar: :any_skip_relocation, mojave:       "f7eae71970cd2ae572c9b301c5a1e1d52d63beb6fd2a979f8aa2fa8379e00397"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b6882621b76d4146b7f5884cbe6434ec4e51c0fb4553ecbed07a6ccfde6dae8a"
  end

  keg_only :versioned_formula

  disable! date: "2022-07-31", because: :versioned_formula

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}"

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
