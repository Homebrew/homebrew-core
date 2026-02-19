class Redict < Formula
  desc "Distributed key/value database"
  homepage "https://redict.io/"
  url "https://codeberg.org/redict/redict/archive/7.3.6.tar.gz"
  sha256 "3d6aedad01f8137beeb2aabc74c128b4eec9a2d0d4433892b855fb2f4e6f39f2"
  license "LGPL-3.0-only"
  head "https://codeberg.org/redict/redict.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cbfd75594013a1049c135b3d0175339033ae49b805707876505700b0d2fd0244"
    sha256 cellar: :any,                 arm64_sequoia: "f4bb5f1a67a1255171d99aeb8f4257e95cbe32f256f59f830ad3439a0692f981"
    sha256 cellar: :any,                 arm64_sonoma:  "0b854006776e9bd8aec252b1363075dac7e41a3d5886f0b203d94aea2238705b"
    sha256 cellar: :any,                 sonoma:        "4b983424da0a10236d0afc57a2a76aa009a883760f80a482880b6060cd77c7bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0599c6e40122c402656b72c5762babea440c71e4c32a89d593704c3be2ce07a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "708796b8af5a02da1959552fb065bd81218b0f2ebfb649d345e0ae86b3db363f"
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
