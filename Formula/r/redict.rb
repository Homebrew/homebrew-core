class Redict < Formula
  desc "Distributed key/value database"
  homepage "https://redict.io/"
  url "https://codeberg.org/redict/redict/archive/7.3.1.tar.gz"
  sha256 "6dbe80d28503a9252048ab81856efcfec109cdf3f924e840411c30237cf8f634"
  license "LGPL-3.0-only"
  head "https://codeberg.org/redict/redict.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c51d3048902188eb14e48540acf61f15953e3dfa9e79f4768a879770c0260b36"
    sha256 cellar: :any,                 arm64_sonoma:  "49a97f9241ac71005818654b5cf3df94b723c3aa1d93b215843b1dc47aa5e580"
    sha256 cellar: :any,                 arm64_ventura: "53252f2cbe9d604eb839e7f3ea35ddeb247e10751faa60ff1045e486ccc54d4a"
    sha256 cellar: :any,                 sonoma:        "861eda33ab95c62769b9049203817c5a18e1ed04cf6b9b31ff9a56debf00644d"
    sha256 cellar: :any,                 ventura:       "d59873868022041578819a5f65fdb85390e24433f241582dbb6568e4d8f00d62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e260e15a6db308008c1608f3cb7d3c75e2a281cb8261a5ea37eeb9edab12f4a9"
  end

  depends_on "openssl@3"

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run db/redict log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redict.conf" do |s|
      s.gsub! "/var/run/redict_6379.pid", var/"run/redict.pid"
      s.gsub! "dir ./", "dir #{var}/db/redict/"
      s.sub!(/^bind .*$/, "bind 127.0.0.1 ::1")
    end

    etc.install "redict.conf"
    etc.install "sentinel.conf" => "redict-sentinel.conf"
  end

  service do
    run [opt_bin/"redict-server", etc/"redict.conf"]
    keep_alive true
    error_log_path var/"log/redict.log"
    log_path var/"log/redict.log"
    working_dir var
  end

  test do
    system bin/"redict-server", "--test-memory", "2"
    %w[run db/redict log].each { |p| assert_predicate var/p, :exist?, "#{var/p} doesn't exist!" }
  end
end
