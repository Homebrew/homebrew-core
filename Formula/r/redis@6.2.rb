class RedisAT62 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-6.2.13.tar.gz"
  sha256 "89ff27c80d420456a721ccfb3beb7cc628d883c53059803513749e13214a23d1"
  license "BSD-3-Clause"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(6\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "590f0b9a56306a34e6aa53c6fa03e1021a04deef819bdf68c1e440c14c47d992"
    sha256 cellar: :any,                 arm64_monterey: "04f7c5e429ab9de51bcae8aa9c7bdbb9cb73312c61b2b2a6e8f19f8c160c19f0"
    sha256 cellar: :any,                 arm64_big_sur:  "1d95294e4e2ea39d82a41370e36d6c9d00f910e1618ce4c23ea1e34cdcac63e0"
    sha256 cellar: :any,                 ventura:        "b9eded6ffd53ddf8ecba1c4b5a3a314bf2da512d06517de5a832429f6dea0818"
    sha256 cellar: :any,                 monterey:       "2fc856b8be810735a54a688344a38be6c96e2ef0c39522715409b934ee02fe86"
    sha256 cellar: :any,                 big_sur:        "9ba7d091d8bb226844d854b2e50988fd04540a236c2997226863eb6ca6a47e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69f610e6153c9882eb8da9d1b0591fd76c202c7d82fb04c191afca3352c9caf1"
  end

  keg_only :versioned_formula

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
