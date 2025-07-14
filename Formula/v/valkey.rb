class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/8.1.3.tar.gz"
  sha256 "6b167eb7072f5785c0c0af807960889a3d346fc3d0ecb571064b019ee365ee00"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3d92b36a7308984c858000b1ed2b7a574940ae4be3969c3dfda5ee99a087d0e8"
    sha256 cellar: :any,                 arm64_sonoma:  "85f5bf261982e28bbfd8449b72ec1fd8c977de64eb6dd032c20d1e088934f2bd"
    sha256 cellar: :any,                 arm64_ventura: "47e6b16b999321d4c45b295b309dfd05e993f99e41ef2854a2cbb07f5f2ed06b"
    sha256 cellar: :any,                 sonoma:        "d85485385b9823a482cedd85f1cb64d6ece353d387d94c9f5f6e970ff347725e"
    sha256 cellar: :any,                 ventura:       "f295763ef4434de5f9afc8be4be619e1f4d5dd51594758c5a5f2d82a0a14407f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92afe27dea0ae5176dd17337e4d7ff07a78ca32af73c26edb5b3e814898b4823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5826effaa339018a131924d08c702cc970910f1131447df69a16bba42fff6d68"
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
