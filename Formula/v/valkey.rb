class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://github.com/valkey-io/valkey/archive/refs/tags/7.2.5.tar.gz"
  sha256 "c7c7a758edabe7693b3692db58fe5328130036b06224df64ab1f0c12fe265a76"
  license "BSD-3-Clause"
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a40c337f18bad2ae274199b35ee1e261b18ed3521a67bc61a0a4cf4169eaa893"
    sha256 cellar: :any,                 arm64_ventura:  "cb62ce022ad11d6c12424a028df11ca21b4c8479c7731124536ab62f9a055522"
    sha256 cellar: :any,                 arm64_monterey: "fffd8f00b86e2c5cf2140c3d178c5834857a77416a043f3427ce9a9b35acf8cc"
    sha256 cellar: :any,                 sonoma:         "9e1451cda196df3bc62b82832ba613af06bca50d3ef4c93450b0ca320244d699"
    sha256 cellar: :any,                 ventura:        "3aec084610e710f07c16a6861a45b0bc539e02ef3b815cc8da9267f5b02a5bfe"
    sha256 cellar: :any,                 monterey:       "4a55fb259562e56eb8df25e92c0fa1fe33eead6ca06c6908e61969173924f62b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "508f9fbd61b282abc3278a4dc015b69c6bcc1c3cf84d0969a3281cab820e6e15"
  end

  depends_on "openssl@3"

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
