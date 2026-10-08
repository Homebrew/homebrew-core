class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.10.2.tar.gz"
  sha256 "b9ffee226b5eecdba98a679260dad764b2a4ebd90dce4ad5ac9e9f3eef9c02b3"
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
  revision 1
  compatibility_version 1
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c3959d984ae34c3a6454bd9a3636d93c92f75b95eca703a089d77f2db1e62d7d"
    sha256 cellar: :any, arm64_tahoe:       "bfa3e42f26843f48a2aa934cc943bb6d8f3e4f1383ad044f55f2e70b8aba4af9"
    sha256 cellar: :any, arm64_sequoia:     "c6067fd35eb174d21b5f77e8f002da2ff841801e29c67930373aa58e64748a37"
    sha256 cellar: :any, arm64_linux:       "5f5854058876a22cd92b3c050d421008842f1280029e0132f59f06f710a00dc7"
    sha256 cellar: :any, x86_64_linux:      "72cf0f14a24d0a5e6609bebaa1056d91c5b7b48ef82b6d866f480e72851a6a06"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "libtool" => :build
  depends_on "python@3.14" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  uses_from_macos "llvm" => :build

  on_macos do
    depends_on "make" => :build # RediSearch needs Make 4.0+
  end

  conflicts_with "valkey", because: "both install `redis-*` binaries"

  def install
    # RediSearch sets `CMAKE_CXX_STANDARD` inside a function without `PARENT_SCOPE`,
    # so no `-std` reaches the compile line and the compiler default is used instead.
    ENV.append "CXXFLAGS", "-std=gnu++20"
    # VectorSimilarity selects its SIMD kernels at runtime via cpu_features.
    ENV.runtime_cpu_detection
    # FIXME: redisbloom's vendored readies has no `OSX_MIN_SDK_VER` past tahoe, leaving `-mmacosx-version-min=` empty
    ENV["OSX_MIN_SDK_VER"] = MacOS.version.to_s if OS.mac?
    # RediSearch looks for Homebrew's `openssl@3` before anything else on macOS
    inreplace "modules/redisearch/src/CMakeLists.txt",
              "/opt/homebrew/opt/openssl@3", formula_opt_prefix("openssl@4")
    system "gmake", "deploy", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes",
           "REDISEARCH_GENERATE_HEADERS=0", "IGNORE_MISSING_DEPS=1", "LTO=0"

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
    %w[run db/redis log].each { |p| assert_path_exists var/p, "#{var/p} doesn't exist!" }

    # Test that all modules can be loaded
    %w[redisbloom.so rejson.so redisearch.so redistimeseries.so].each do |file|
      output = shell_output("#{bin}/redis-server --loadmodule #{lib/"redis/modules"/file} --test-memory 2 2>&1", 1)
      assert_match(/Module.*loaded from/, output)
    end
  end
end
