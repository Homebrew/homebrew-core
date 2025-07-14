class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.0.3.tar.gz"
  sha256 "33f37290b00b14e9a884dd4dcba335febd63ea16c51609d34fa41e031ad587df"
  license all_of: [
    "AGPL-3.0-only",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5e366c26f694f49511ceb52a6643c668a2b0cd9f364dc7992dfa4d4660232657"
    sha256 cellar: :any,                 arm64_sonoma:  "651c269ef73a3c563511c8db166d356c53b1d2cf26e543371ccfe12da83cf1c2"
    sha256 cellar: :any,                 arm64_ventura: "d45e17776fac90d1f78c2b3b6cf02bf878226a03a78151308233880fc42b0d72"
    sha256 cellar: :any,                 sonoma:        "93f01abd5bdabe2b6650021cc39b68df96da346a57305d13300f3660876c0797"
    sha256 cellar: :any,                 ventura:       "91607bedc4d8cedb6cfea5f059a05b00fed40f321cb3a9e1bf8b4cd3cbc03c0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4055f597560bc63e238f9b79135fd7ac2f11a9c4972c5e821fb43226c5ac39d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8665aa98da4e64ecbd657448efc309444e4c7a19c46ec572b897759723d7f95e"
  end

  depends_on "openssl@3"

  conflicts_with "valkey", because: "both install `redis-*` binaries"

  def install
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
