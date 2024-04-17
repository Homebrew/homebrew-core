class Redict < Formula
  desc "Distributed key/value database"
  homepage "https://redict.io/"
  url "https://codeberg.org/redict/redict/archive/7.3.0.tar.gz"
  sha256 "733880c043c04d6038c28e77f2e826143142929be9c4a68f82a4f66e7a0caf5c"
  license "LGPL-3.0-only"
  head "https://codeberg.org/redict/redict.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8ca12acea855c46b02c65d36f63b9810aad63ed14ac83473fb498cfe0768ed4f"
    sha256 cellar: :any,                 arm64_ventura:  "6ef318d2319f9b5f18cffd399f96dcbc035cf8cf3b75fa489cd9955e6ab1cf4d"
    sha256 cellar: :any,                 arm64_monterey: "8b302580ed161bb8384e30bd0b50eadbe1047acb28e6bf6b5b38341e82395efe"
    sha256 cellar: :any,                 sonoma:         "d25a7b2be916065e911a12c603f456ab0a4c1989657c0a3771def4bc3b37d4da"
    sha256 cellar: :any,                 ventura:        "dcdb052b3a407a79dac689eb75e2717244262dee5dffe5f960cca18f7098bf19"
    sha256 cellar: :any,                 monterey:       "0dc52fb15437fabbf7751b6af6d08821abb7ace122be254dff821da411ee31d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d93edbb84f2a3a547296b8a8afa0c33f9d5687ddf0ae8b2699207df9ddb8f65"
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
