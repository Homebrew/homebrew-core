class Redict < Formula
  desc "Distributed key/value database"
  homepage "https://redict.io/"
  url "https://codeberg.org/redict/redict/archive/7.3.6.tar.gz"
  sha256 "3d6aedad01f8137beeb2aabc74c128b4eec9a2d0d4433892b855fb2f4e6f39f2"
  license "LGPL-3.0-only"
  head "https://codeberg.org/redict/redict.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "65aa1f140b1e4cb883c637eefe8f438ca503a288b9bb13c2d8e36011958e2a71"
    sha256 cellar: :any,                 arm64_sequoia: "10c29e718cf279452ce6c8f37dbaeaf20e0b2119ca2e36c7311a219ec6cc856f"
    sha256 cellar: :any,                 arm64_sonoma:  "26c2ddd2d2f29751010d4cc3a53de063cc32af3450cdb7b408a1f45ccf6591c6"
    sha256 cellar: :any,                 sonoma:        "bbad4f944c6da2efc7c3a7a62e8557aced278412af8a9dd0e561240fa39928b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52fa830f4104592b333f01c5fcffeb13edc0abdaa0231bd1f3ea4231b3b27dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03bd484b1b690757e7ddcb5e0ab7c7145f7eafa0374b7e6282fd70f1b850e1f9"
  end

  depends_on "openssl@4"

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
