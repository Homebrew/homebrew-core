class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-7.0.2.tar.gz"
  sha256 "5e57eafe7d4ac5ecb6a7d64d6b61db775616dbf903293b3fcc660716dbda5eeb"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "79e59848cb1afb3107612980c29c85d321e8abec277983f42ab36ffb6cf8d954"
    sha256 cellar: :any,                 arm64_big_sur:  "3229c802fdc70bf1f0b81678098045971997e13f6002ce724f83d3827a3fbe43"
    sha256 cellar: :any,                 monterey:       "05a9eddf3ed94176ce4802f18f174f579209f298aa69131da1675833dde2f897"
    sha256 cellar: :any,                 big_sur:        "767ba47c137bdce3ca32675bc6ae327df5fdaa9c62bd9f2968c779c7582aafb2"
    sha256 cellar: :any,                 catalina:       "abc124047bc5e83dea48e57b1e178ace5fb33340d59b45ae965c3f9c6af8304f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3b7252cb63246281ec69255603287c8a69aa139e21cf4d234ae2ddfe4befbe8"
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
