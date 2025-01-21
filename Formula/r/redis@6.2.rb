class RedisAT62 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-6.2.17.tar.gz"
  sha256 "f7aab300407aaa005bc1a688e61287111f4ae13ed657ec50ef4ab529893ddc30"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(6\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c0d523433af8204bbbd53e5c1aa50b3574c1342b5abe4424a7fc9b36f7a876c8"
    sha256 cellar: :any,                 arm64_sonoma:  "fc7299088a3bcac3622b6ac989e8b7940be61c81722225773faa240c87abb0a2"
    sha256 cellar: :any,                 arm64_ventura: "9973968101766929fec84af343a7754b47bb8062be4652fc5160ad19ca4b5477"
    sha256 cellar: :any,                 sonoma:        "5f0ad9a046f4ae0654b46f76cf69d36773a6aad900d7fa21897514eb1f60f803"
    sha256 cellar: :any,                 ventura:       "537619f990811b28b27c14a391056d935a1d2ad9f8efd080ff14b0404a84a051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1893c1963810ca04db43e71b2ea91c019c562f5954e794b574d86ff93bca70d8"
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
