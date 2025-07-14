class Redict < Formula
  desc "Distributed key/value database"
  homepage "https://redict.io/"
  url "https://codeberg.org/redict/redict/archive/7.3.5.tar.gz"
  sha256 "1528db77c3539190ebe1fe3963347e02ac8095aff75a19b3373cddcf3f920405"
  license "LGPL-3.0-only"
  head "https://codeberg.org/redict/redict.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c1444697872fc03c6329c6d3dbff23866eb486410b1c358a90e7b480098ae1c3"
    sha256 cellar: :any,                 arm64_sonoma:  "9c660fb94b6860a1d61177918dc03892b2a2e88b4314bacba9087e0fe997e6e0"
    sha256 cellar: :any,                 arm64_ventura: "411e38125ae432e5fed2c908831809e39e6c468fee18ea4c1297675c2172f8ab"
    sha256 cellar: :any,                 sonoma:        "974d235c88dd6766946ce208be538788507540fe95668ed4ab8044f147801936"
    sha256 cellar: :any,                 ventura:       "dcf0952b6f456dfc62238234226cec35f577394785281e3113087ad3e66aeab5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae0d80bdeeba521f6be843c38035bfb52430facb25c9eae3071499a07d6b17f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9af1fbc514cdee0c7e6d7df046d733d34b76f7f515c8c7c8b6f818525f3ae6be"
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
    %w[run db/redict log].each { |p| assert_path_exists var/p, "#{var/p} doesn't exist!" }
  end
end
