class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-7.2.3.tar.gz"
  sha256 "3e2b196d6eb4ddb9e743088bfc2915ccbb42d40f5a8a3edd8cb69c716ec34be7"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "23c83c2292295aa8fbff3e5fed32ea4adeab24ab62ec6c1ffe18cc47f992bd4b"
    sha256 cellar: :any,                 arm64_ventura:  "8cd2c853a83c69e2a92c51d8ab3d3449d957929cef20659fdb98478b18a7c7ee"
    sha256 cellar: :any,                 arm64_monterey: "f2bfdbd496e880913366a7725958e34d2a4dc75455777c2962c840a5c1705b76"
    sha256 cellar: :any,                 sonoma:         "0d92f5556242d47cf5ff0414dd547428e871a2a51ac9ce201797528597a391ac"
    sha256 cellar: :any,                 ventura:        "04dc20745c12632edfc1b13e41a24309b0d040f6d98a65d7987cf7390b0e965a"
    sha256 cellar: :any,                 monterey:       "97119a402b18cdabea81249da9357f8d5439682b5a297e4fb2c561b252ea7359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cde07bcbe0f8589935c35c1ff212a3ee8d70e894c930d4a88678d1e447ca76a"
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
