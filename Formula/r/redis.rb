class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.12.0.tar.gz"
  sha256 "b0100a879b2d45dc97d8fda941127609d648f8913008db1b65a2f72a8ae36c8b"
  license all_of: [
    "AGPL-3.0-only", # modules: VectorSimilarity, LibMR
    "Apache-2.0", # modules: ScalableVectorSearch, cpu_features, friso, cndict
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*, deps/tre, deps/xxhash, modules: bloom
    "BSD-3-Clause", # modules: libevent, hiredis, readies, snowball, stemmers
    "BSL-1.0", # deps/fpconv, modules: boost, eve, dragonbox, fast_double_parser
    "MIT", # deps/lua, modules: fmt, spdlog, robin-map, tomlplusplus, fast_float, t-digest-c, libnu, libuv, miniz
    { any_of: ["CC0-1.0", "BSD-2-Clause"] }, # deps/hdr_histogram
    any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"], # modules: phonetics
  ]
  compatibility_version 1
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "359b281af8785bee8472883be15a8aba43f6b7046bc60a2f12a92ab4526609ba"
    sha256 cellar: :any, arm64_golden_gate: "490582c9a9634c7b6cab2d695d5813443412eac688ceed61c3c254b3c233d779"
    sha256 cellar: :any, arm64_tahoe:       "140542d67ca7bca18590e1fbb0bc90cee541b4dad5f32a1e31a822707c01b643"
    sha256 cellar: :any, arm64_sequoia:     "94a1a3da5058a7ef2ca0aeee04b422f61c7ba2a6915e6c94c071e505b01a1c11"
    sha256 cellar: :any, arm64_linux:       "98ba461fa99ef56c4e3560098338d49f6be73e321f8ddf85b4b2bb3aa07dc5e3"
    sha256 cellar: :any, x86_64_linux:      "f67ac5cec2ef46cc0208415af7621df80cfbd383951bd2c4af280ee20022997b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "libtool" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"
  depends_on "zstd"

  uses_from_macos "llvm" => :build
  uses_from_macos "python" => :build

  on_macos do
    depends_on "make" => :build # RediSearch needs Make 4.0+
  end

  conflicts_with "valkey", because: "both install `redis-*` binaries"

  def install
    # VectorSimilarity selects its SIMD kernels at runtime via cpu_features.
    ENV.runtime_cpu_detection
    system "gmake", "deploy", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes",
           "BUILD_COMPRESSION=yes", "REDISEARCH_GENERATE_HEADERS=0", "IGNORE_MISSING_DEPS=1", "LTO=0"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis_6379.pid", var/"run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.sub!(/^bind .*$/, "bind 127.0.0.1 ::1")
      s.gsub! "#{lib}/redis/modules", "#{opt_lib}/redis/modules"
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
  end

  post_install_steps do
    # The modules are plugins that redis opens rather than links against, it checks that
    # an execute bit is set and fails otherwise.
    set_permissions "redis/modules/*", "0755", base: :lib
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
    %w[run db/redis log].each { |p| assert_path_exists var/p, "#{var}/#{p} doesn't exist!" }

    # Test that all modules can be loaded
    %w[redisbloom.so rejson.so redisearch.so redistimeseries.so].each do |file|
      output = shell_output("#{bin}/redis-server --loadmodule #{lib}/redis/modules/#{file} --test-memory 2 2>&1", 1)
      assert_match(/Module.*loaded from/, output)
    end
  end
end
