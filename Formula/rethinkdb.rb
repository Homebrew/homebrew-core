class Rethinkdb < Formula
  desc "Open-source database for the realtime web"
  homepage "https://rethinkdb.com/"
  url "https://download.rethinkdb.com/repository/raw/dist/rethinkdb-2.4.1.tgz"
  sha256 "5f1786c94797a0f8973597796e22545849dc214805cf1962ef76969e0b7d495b"
  license "Apache-2.0"
  head "https://github.com/rethinkdb/rethinkdb.git", branch: "next"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "1c2ef66f6bf7d2efdf55b377032955905186c74a0dacf1306665671931e1159c" => :catalina
    sha256 "5db706fb3f48f378771f5076d167e3d3dc5441b328e3b194e7337fe7bd7dde97" => :mojave
    sha256 "7d37fba07988bc8adc4ef0dece038adf443b02d868fdf22d018360fb8958383b" => :high_sierra
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

  plist_options manual: "rethinkdb"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/rethinkdb</string>
            <string>--config-file</string>
            <string>#{etc}/rethinkdb.conf</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/rethinkdb/rethinkdb.log</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/rethinkdb/rethinkdb.log</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    shell_output("#{bin}/rethinkdb create -d test")
    assert File.read("test/metadata").start_with?("RethinkDB")
  end
end
