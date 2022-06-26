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
    sha256 cellar: :any,                 arm64_monterey: "526deec472da0768a5fe8d2f0617495f3c43befee02ae57ca723c01dae30be31"
    sha256 cellar: :any,                 arm64_big_sur:  "8e46ce2ed889f499c7c49823cb9b97a949047c4e2ee7876eb6404415221d0390"
    sha256 cellar: :any,                 monterey:       "ae3e94acbf74e76afbf42a7627bc91864191f8530e0a04b6b11c187b0340bb4a"
    sha256 cellar: :any,                 big_sur:        "d477311ecd22f1cb31ce1207daf6ec22a6bd995bed85d65ffe0fad1077dbf275"
    sha256 cellar: :any,                 catalina:       "ed3cd661095c0cf85988ce93d2f32123b984c6b523708065808a6d2fc6f615a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a60623e87e59fa76b87a32f036430e1379a5c19fe4c48151b42a2d5aa3c0032"
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
