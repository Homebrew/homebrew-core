class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/8.1.0.tar.gz"
  sha256 "559274e81049326251fa5b1e1c64d46d3d4d605a691481e0819133ca1f1db44f"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a3bfda8c080477488d634d1b1c2bc3b4de22fe2fa9582d08c0d2ad16c69f6ef4"
    sha256 cellar: :any,                 arm64_sonoma:  "e501cc12632ac3e4c0c40ffbe782ed732bebde22960d661b33e4942d3a6d3116"
    sha256 cellar: :any,                 arm64_ventura: "142f662d416b006bbd26c554aa14d8295bc395ed18cf6ab9a2068a799d36f9fc"
    sha256 cellar: :any,                 sonoma:        "4555d9be63ff5e4d940317879938dc30400f4f07ca7323c35b8450b5ad023e28"
    sha256 cellar: :any,                 ventura:       "e62a634073f04fd279c20c1e36620107fc5fc7ae398a2f28063ef3bf52309982"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11b6de99f06f93a2f428c27f3978fc4ed2b7c279ed3042b209893e51861ec5ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf1b90afba22672fdc6066ce83d3c79b2b18cc95e12c96bc1ae4b9003fe35b86"
  end

  depends_on "openssl@3"

  conflicts_with "redis", because: "both install `redis-*` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run db/valkey log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "valkey.conf" do |s|
      s.gsub! "/var/run/valkey_6379.pid", var/"run/valkey.pid"
      s.gsub! "dir ./", "dir #{var}/db/valkey/"
      s.sub!(/^bind .*$/, "bind 127.0.0.1 ::1")
    end

    etc.install "valkey.conf"
    etc.install "sentinel.conf" => "valkey-sentinel.conf"
  end

  service do
    run [opt_bin/"valkey-server", etc/"valkey.conf"]
    keep_alive true
    error_log_path var/"log/valkey.log"
    log_path var/"log/valkey.log"
    working_dir var
  end

  test do
    system bin/"valkey-server", "--test-memory", "2"
    %w[run db/valkey log].each { |p| assert_path_exists var/p, "#{var/p} doesn't exist!" }
  end
end
