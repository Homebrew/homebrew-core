class Redict < Formula
  desc "Distributed key/value database"
  homepage "https://redict.io/"
  url "https://codeberg.org/redict/redict/archive/7.3.2.tar.gz"
  sha256 "c00ddb7d9eea879b3effc3dd7d1a8cff954fb472915ab9002ec56068c3af2a73"
  license "LGPL-3.0-only"
  head "https://codeberg.org/redict/redict.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "328f0f111c46fc1d380c5e1acd5ec33921ba3e09d17d641417a88eadad7175c1"
    sha256 cellar: :any,                 arm64_sonoma:  "cc7e758ad4aacebedfbd5c37eb24e5307f96503f6b4f4b5d636eb809b801e262"
    sha256 cellar: :any,                 arm64_ventura: "4cce348e146a06b8d0c37acaca2145c757fb9d06e82d9c4d6e795535b6cd8612"
    sha256 cellar: :any,                 sonoma:        "2b7de6bb7792f2a638a7f4eb451b2c707edd24f86c64cb7a684ce0c417728bbc"
    sha256 cellar: :any,                 ventura:       "3b40b26736ebb37ede153bae2781814dfc3483ab1d87453faf6ee54d0780e4b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f263225a18773c4485583261e0d06cb6b7eac9b776713b11c6d58eba584ee2dd"
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
