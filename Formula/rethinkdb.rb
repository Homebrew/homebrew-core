class Rethinkdb < Formula
  desc "Open-source database for the realtime web"
  homepage "https://rethinkdb.com/"
  url "https://download.rethinkdb.com/repository/raw/dist/rethinkdb-2.4.1.tgz"
  sha256 "5f1786c94797a0f8973597796e22545849dc214805cf1962ef76969e0b7d495b"
  license "Apache-2.0"
  head "https://github.com/rethinkdb/rethinkdb.git", branch: "next"

  livecheck do
    url "https://download.rethinkdb.com/service/rest/repository/browse/raw/dist/"
    regex(/href=.*?rethinkdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "bb4dc60cb80b346f5c095af46c195c6d54cc927531f690889c2d5256f55a63b4"
    sha256 cellar: :any, catalina: "31fa08475118f77ecd8785bac8b59c1f5732171a5c0c8ec44087fbbb559cb95b"
    sha256 cellar: :any, mojave:   "3aff9d5aff3f0bc1318f8b53e04d2b688560fcf4911f64d6c963d38f78a88316"
  end

  depends_on "boost" => :build
  depends_on :macos # Due to Python 2 (v8 and gyp fail to build)
  # https://github.com/Homebrew/linuxbrew-core/pull/19614
  # https://github.com/rethinkdb/rethinkdb/pull/6401
  depends_on "openssl@1.1"

  uses_from_macos "curl"

  # patch submitted to upstream, https://github.com/rethinkdb/rethinkdb/pull/6934
  # remove in next release
  patch do
    url "https://github.com/chenrui333/rethinkdb/commit/d7d22b4.patch?full_index=1"
    sha256 "45d387c3360cf6265e27485c273c37224b2ef0000ebd4fdd361dcecc4d2e9791"
  end

  def install
    # rethinkdb requires that protobuf be linked against libc++
    # but brew's protobuf is sometimes linked against libstdc++
    args = %W[--prefix=#{prefix} --fetch protobuf]
    args << "--allow-fetch" if build.head?

    system "./configure", *args
    system "make"
    system "make", "install-osx"

    (var/"log/rethinkdb").mkpath

    inreplace "packaging/assets/config/default.conf.sample",
              /^# directory=.*/, "directory=#{var}/rethinkdb"
    etc.install "packaging/assets/config/default.conf.sample" => "rethinkdb.conf"
  end

  service do
    run [opt_bin/"rethinkdb", "--config-file", etc/"rethinkdb.conf"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/rethinkdb/rethinkdb.log"
    error_log_path var/"log/rethinkdb/rethinkdb.log"
  end

  test do
    shell_output("#{bin}/rethinkdb create -d test")
    assert File.read("test/metadata").start_with?("RethinkDB")
  end
end
