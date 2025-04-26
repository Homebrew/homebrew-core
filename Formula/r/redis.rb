class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  # NOTE: Do not bump to v7.4+ as license changed to RSALv2+SSPLv1
  # https://github.com/redis/redis/pull/13157
  url "https://download.redis.io/releases/redis-7.2.8.tar.gz"
  sha256 "6be4fdfcdb2e5ac91454438246d00842d2671f792673390e742dfcaf1bf01574"
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
    sha256 cellar: :any,                 arm64_sequoia: "422ceee1d954c13e3ef3e940035fe75f2e2712319b6b5bb1eeed658ded2b12b7"
    sha256 cellar: :any,                 arm64_sonoma:  "56d106290e90037ede6773cde5c12394eae99668f09224e29bfcd3db5b153771"
    sha256 cellar: :any,                 arm64_ventura: "1b817d307ec8177b7bcba525278811821fbadf55240213662ec8ab4c1b55f68d"
    sha256 cellar: :any,                 sonoma:        "3737eb64b386d6db0d669d14f1a7845521005b3c1b05dc28b708d36dc156ee6c"
    sha256 cellar: :any,                 ventura:       "3f5e3719abcde6fc5bd0d9ca464ef9900c947af9c91b70740f5e95a4d0fdeded"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "793caff571d28c1ee9f3356b2b38cca3b1ec9a754015aec1ebffcf8d99611c47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b4a4dcd5d96ced2bd006de2d3cb98cbc2df5063c271025fd1f9985f1bf04660"
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
    %w[run db/redis log].each { |p| assert_path_exists var/p, "#{var/p} doesn't exist!" }
  end
end
