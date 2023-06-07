class RedisAT62 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-6.2.12.tar.gz"
  sha256 "75352eef41e97e84bfa94292cbac79e5add5345fc79787df5cbdff703353fb1b"
  license "BSD-3-Clause"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(6\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e4ab1b412752c90bb2b9ee9296ca9c0d86059629403d138834fa7d5ab976396d"
    sha256 cellar: :any,                 arm64_monterey: "60535f0e1828c4a0911dfe2bed40fc7f4607b3d89eb89af5b4a4fa91eca19fde"
    sha256 cellar: :any,                 arm64_big_sur:  "e19bb588f97ec41c5390dc1ec74ca2bd1b9add22b3ace7604555b65a9283de5d"
    sha256 cellar: :any,                 ventura:        "62d7baff8de8e2bb9b693bb978c3aee8b1756dfafa4cd0a97f9333bc61aa2686"
    sha256 cellar: :any,                 monterey:       "a5dd3f2ca33d204030ab035bbd57d1036bf30b1ce5b980b459e1b4caed449b60"
    sha256 cellar: :any,                 big_sur:        "a7499ce56b4def3c7548301bfa9e5de0bdf0be37f0c564b0d8415a84b05655d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fb52b78ae622ea74a317af157a173aa8ef365191fb49c8297034cd0d8a6aef6"
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
