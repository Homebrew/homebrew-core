class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/7.2.4-rc1.tar.gz"
  sha256 "cd0a74184f2e6addac458f7b4f7549521e490a4ef51db0eb1dccd1a520de4cb6"
  license "BSD-3-Clause"
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "379bf80808797ec3c9885baf86e5426360171c7c9663db664fe4f73575bd7dce"
    sha256 cellar: :any,                 arm64_ventura:  "cff11b3943ce50a90fa31f75fe062191c95acd1b0fcd4361fa4b2857b2333105"
    sha256 cellar: :any,                 arm64_monterey: "f6ccd387476c12611ea90f45e55e0cb31cf21db04489b37be1a06f71814fec55"
    sha256 cellar: :any,                 sonoma:         "fbfd66eafd961bb2c5af5de4dac9fa92cd75ad9f55e0410c49b1c6b95606b121"
    sha256 cellar: :any,                 ventura:        "4e11ec6456fcfeaeb69ce7b2c6b5e74d25c412ca8612cb61b83605f0ca8e48a7"
    sha256 cellar: :any,                 monterey:       "75b05936f7419e56de73eb410e9a112bd65a30a308bbe6e60a1c61cf718666a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be464c47d5f879ea10eda3ffac294134394c10c6f44a33c8295a4da7668c9e73"
  end

  depends_on "openssl@3"

  conflicts_with "redis", because: "both install `redis` binaries"

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
    %w[run db/valkey log].each { |p| assert_predicate var/p, :exist?, "#{var/p} doesn't exist!" }
  end
end
