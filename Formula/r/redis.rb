class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  # NOTE: Do not bump to v7.4+ as license changed to RSALv2+SSPLv1
  # https://github.com/redis/redis/pull/13157
  url "https://download.redis.io/releases/redis-7.2.6.tar.gz"
  sha256 "fb10d67a2fe2b4556f6cb840064dd6e6e3175ce8ca035f0726990ec2da9f3d0e"
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
    sha256 cellar: :any,                 arm64_sequoia: "d842dec721e3f9cfca9d83a956ede1879ff4a70e19789c3dd81e56a1abd3ff5f"
    sha256 cellar: :any,                 arm64_sonoma:  "7009ae4f7236e3c804eee9ff0d13c894210df5ac38ddb45e19fc267c41fb88e5"
    sha256 cellar: :any,                 arm64_ventura: "a82aaad22347edb2014c22a01ce1eb0cd4f7003450b66d6090326d90f1c79d43"
    sha256 cellar: :any,                 sonoma:        "cf0ef328040d86d4384b4c98c1c7fb6f1e52dd8435e3a509af4a691c4fa75dc3"
    sha256 cellar: :any,                 ventura:       "86fd919d0843317ab4e20f9d62355c6534b002be775ddcbe7e095d58ecbb8d85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1028b677934a0257d5c072740db15ea77b7187c53737d040157d0c5c3d9fa650"
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
