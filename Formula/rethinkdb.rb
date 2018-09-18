class Rethinkdb < Formula
  desc "The open-source database for the realtime web"
  homepage "https://www.rethinkdb.com/"
  url "https://download.rethinkdb.com/dist/rethinkdb-2.3.6.tgz"
  sha256 "c42159666910ad01be295a57caf8839ec3a89227d8919be5418e3aa1f0a3dc28"

  bottle do
    cellar :any
    sha256 "ba85df2995a353785371e679d208e711c4b34bf8fdff2007dd4f366fe9dfde51" => :mojave
    sha256 "eaa4700adc14905f388602c44008cbefcd2ac5c22a4a23e6871058a5f1a2a7ca" => :high_sierra
    sha256 "1f936e43b0cb7b321d9a14a2f2de994154162ca5bb656c8583506ca253eadf6b" => :sierra
    sha256 "d090123ea89626f60caa5517b1416b669d3cacfd51fcedfdcd6f58020e941190" => :el_capitan
    sha256 "a17c6864cef6dfc7f1e8ab7da2fcd640d85a504991c0d61175e2f6c78e1ba6ee" => :yosemite
  end

  depends_on "boost" => :build
  depends_on :macos => :lion
  depends_on "openssl"

  fails_with :gcc do
    build 5666 # GCC 4.2.1
    cause "RethinkDB uses C++0x"
  end

  # Fix error with Xcode 9, patch merged upstream:
  # https://github.com/rethinkdb/rethinkdb/pull/6450
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/fb00ee376a/rethinkdb/xcode9.patch"
      sha256 "abd50d91a247ee7de988020dd9d405a3d4cd93edb2875b7d5822ba0f513f85a0"
    end
  end

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

  def plist; <<~EOS
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
