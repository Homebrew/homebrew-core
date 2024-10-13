class RedisAT62 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-6.2.16.tar.gz"
  sha256 "846bff83c26d827d49f8cc8114ea9d1e72eea1169f7de36b8135ea2cec104e7d"
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
    sha256 cellar: :any,                 arm64_sequoia: "7abba1a6474a28e8c444628a467866c6bdf5e83d5108f365945b53063f2b7a80"
    sha256 cellar: :any,                 arm64_sonoma:  "fcbc749f74fee167434140ced5e181b06f64d0c09857bf96b1986389f6d083a1"
    sha256 cellar: :any,                 arm64_ventura: "b9d07d49325e680c1e4f43365b51a82f002819bed1b5b5fed34e988456738a86"
    sha256 cellar: :any,                 sonoma:        "184f870adf82d884dcf46ad56a3d32fba9fe4752ef228d05c3f8f50865d4b699"
    sha256 cellar: :any,                 ventura:       "40cf7191cd0e7124189f6b03e5d581978f12cc2c232d1056a1ace4ba6f6347b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3c272df283ec4c41f8aa34eea6bd294a28b8d859e9892091133d92904f277f6"
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
