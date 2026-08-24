class Redict < Formula
  desc "Distributed key/value database"
  homepage "https://redict.io/"
  url "https://codeberg.org/redict/redict/archive/7.3.6.tar.gz"
  sha256 "868220e6b51062709420f6b2343f03c98eac113c77eefac4626ba909085504f7"
  license "LGPL-3.0-only"
  head "https://codeberg.org/redict/redict.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "65391c26762bfb75511135a365b49c9213b5161e86aa8458e57de115e2fad077"
    sha256 cellar: :any, arm64_sequoia: "e4e4c16c3f1c7b01213b47b6d0affbf52b45a7f0145311879bc756a3b4e2c8fe"
    sha256 cellar: :any, arm64_sonoma:  "b2ceb5d7367908e02cbbf486da477c4a75acc7209a898274d54427099420c7c9"
    sha256 cellar: :any, sonoma:        "8911f668e8a53a6da9744aa1da3b29bedba39857f642424cdac6d6e1a3adff62"
    sha256 cellar: :any, arm64_linux:   "9a2dd76258ccec6927622015e2d3725a49d597f3691559f0b01618c76117623a"
    sha256 cellar: :any, x86_64_linux:  "f3d5dc51db439c55fe2cbc08aa868b3ce49a2c40f37104f8d5b8cf21d8b72a34"
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
