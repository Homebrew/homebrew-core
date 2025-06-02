class Redict < Formula
  desc "Distributed key/value database"
  homepage "https://redict.io/"
  url "https://codeberg.org/redict/redict/archive/7.3.3.tar.gz"
  sha256 "2248be901a5b368f0c73359c98f27c38a860626b4fe0bf83e6c91f5f50534390"
  license "LGPL-3.0-only"
  head "https://codeberg.org/redict/redict.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a19314bcdf7ec4f029a43d7fb5b476202afba06809a72585525dcad2fc86134"
    sha256 cellar: :any,                 arm64_sonoma:  "0b2ebed5253b082b293292257489aa5588c0a55babf3104b4744a0268c5e1021"
    sha256 cellar: :any,                 arm64_ventura: "89e1f2d09251d9b8c47e32c837a782a54d63627bedbfa624e11e1ca507209513"
    sha256 cellar: :any,                 sonoma:        "47b363ffef54a406ae856413c06f3dfd8ea65d642ecee8250b836df3527a89c4"
    sha256 cellar: :any,                 ventura:       "e318935fdd2b135692e16f23ec9f26d7302c9231dfed7fdbe76d046db6f4b434"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6270b337d197176772b5bda6c2d4dfb8a6839488f13b3215b803b61b1b345891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02bf0fbcf1c3b356c69f4e6ace26016dc9a77ff96cf10447e9fdca793154197f"
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
