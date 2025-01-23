class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  # NOTE: Do not bump to v7.4+ as license changed to RSALv2+SSPLv1
  # https://github.com/redis/redis/pull/13157
  url "https://download.redis.io/releases/redis-7.2.7.tar.gz"
  sha256 "72c081e3b8cfae7144273d26d76736f08319000af46c01515cad5d29765cead5"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      version_limit = Version.new("7.4")
      page.scan(regex).map do |match|
        match[0] if Version.new(match[0]) < version_limit
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aefa0dd010a6707c9814f24a0d0e20deeaba297958fe901a4786204970815e0f"
    sha256 cellar: :any,                 arm64_sonoma:  "f52f75401515e756b6ab71953ea1d3c10dbcd6b16bc9afb016ff20695bd2053e"
    sha256 cellar: :any,                 arm64_ventura: "45d4fd71c45fc068ddef77c8159e5516d73b14d6076c2d8ccf379640ea9dc3be"
    sha256 cellar: :any,                 sonoma:        "ea691d1b50bf68112f6ba65836ef1af4e9d2869d2aa72959da62cf22075b5402"
    sha256 cellar: :any,                 ventura:       "db2bbb4405291b3918fe4f0f11b68460f407a5f8d1127b41abfe0acfa9d3bb01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35b84640a9a360afa2fabe95ad44cec532c7c8c0a2a46c1a636b874125cf9ca3"
  end

  depends_on "openssl@3"

  conflicts_with "valkey", because: "both install `redis-*` binaries"

  def install
    odie "Do not bump to v7.4+" if version.major_minor >= "7.4"

    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis_6379.pid", var/"run/redis.pid"
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
