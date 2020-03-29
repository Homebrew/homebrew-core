class Rethinkdb < Formula
  desc "The open-source database for the realtime web"
  homepage "https://www.rethinkdb.com/"
  url "https://download.rethinkdb.com/dist/rethinkdb-2.4.0.tgz"
  sha256 "bfb0708710595c6762f42e25613adec692cf568201cd61da74c254f49fa9ee4c"
  revision 1

  bottle do
    cellar :any
    sha256 "ce3f886f880a43649c486fcc6c467e3ca44f526f06c4abeb7509e949b43b600e" => :catalina
    sha256 "7ecafe14d01b8289df21dae7cc8f6d6313bd2adb0e690be386d3bb09cf0efae8" => :mojave
    sha256 "fcec71e74c936790031c212773b91aea4c62fb80c0e25207c1162c3a486bf2da" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"
  # Does not support python 3, as stated in the readme
  # v8 and gyp fail to build: https://github.com/Homebrew/linuxbrew-core/pull/19614
  # See also https://github.com/rethinkdb/rethinkdb/pull/6401
  uses_from_macos "python@2"

  def install
    args = ["--prefix=#{prefix}"]

    # rethinkdb requires that protobuf be linked against libc++
    # but brew's protobuf is sometimes linked against libstdc++
    args += ["--fetch", "protobuf"]

    system "./configure", *args
    system "make"
    system "make", "install-osx"

    (var/"log/rethinkdb").mkpath

    inreplace "packaging/assets/config/default.conf.sample",
              /^# directory=.*/, "directory=#{var}/rethinkdb"
    etc.install "packaging/assets/config/default.conf.sample" => "rethinkdb.conf"
  end

  plist_options :manual => "rethinkdb"

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
