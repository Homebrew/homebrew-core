class Rethinkdb < Formula
  desc "The open-source database for the realtime web"
  homepage "https://www.rethinkdb.com/"
  url "https://download.rethinkdb.com/dist/rethinkdb-2.3.6.tgz"
  sha256 "c42159666910ad01be295a57caf8839ec3a89227d8919be5418e3aa1f0a3dc28"
  revision 1

  bottle do
    cellar :any
    sha256 "47ba903ac7a898a08135cabf1b51880541d469b4dfe31c890420319828051574" => :catalina
    sha256 "134b8075ce3fc70993a15e6e909a5c4e87fa40013288c6ae6e1504a17135db78" => :mojave
    sha256 "8ba94c5670a91302eddee0924ea02cfc537d198f9b070c9fe9dc39d144f3391d" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "openssl@1.1"

  # Fix error with Xcode 9, patch merged upstream:
  # https://github.com/rethinkdb/rethinkdb/pull/6450
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/fb00ee376a/rethinkdb/xcode9.patch"
      sha256 "abd50d91a247ee7de988020dd9d405a3d4cd93edb2875b7d5822ba0f513f85a0"
    end
  end

  # Upstream commit for OpenSSL 1.1 compatibility
  patch do
    url "https://github.com/rethinkdb/rethinkdb/commit/62456155.diff?full_index=1"
    sha256 "6666074788d7de3295619426350c96b1f2e2e3b2427e76511dc168447034cacd"
  end

  # Upstream fix for Boost >= 1.69
  patch do
    url "https://github.com/rethinkdb/rethinkdb/commit/04785087.diff?full_index=1"
    sha256 "a26e452ce1f16541a9ba40057af154e594fe89665c2c656994ceab103d2017e9"
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
