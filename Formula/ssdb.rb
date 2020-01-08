class Ssdb < Formula
  desc "NoSQL database supporting many data structures: Redis alternative"
  homepage "http://ssdb.io/"
  url "https://github.com/ideawu/ssdb/archive/1.9.4.tar.gz"
  sha256 "6a24efcc906faf07c02c69975861368c1aa8e4adb3770f4bcd3dd610cdcce537"
  head "https://github.com/ideawu/ssdb.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae4601d4ea8edc2c7229eb0f482f68b32f3da7893aa59ab2f65d93c103f553b2" => :catalina
    sha256 "e0909c2c863ae8995a2a2e28caa9e14f0a410e02bed59e3e1d099264ee1f0ba8" => :mojave
    sha256 "b6682e1b7e93c577e69c60308cc99a0e7124ddc48006207d963888863fb21dd9" => :high_sierra
    sha256 "79903c5f68970f2c92716aa357dc7d02842ab9838aed81eb0d10a84a6b7b3277" => :sierra
    sha256 "ea82ea4a73dca47ff68b7cfaf205373302709946aaecadd8d71d71741ca02f13" => :el_capitan
    sha256 "24f875e83c5457735183542c8c173c01eb08bcf819dc38042f34f0114d220f3f" => :yosemite
  end

  depends_on "autoconf" => :build

  def install
    inreplace "tools/ssdb-cli", /^DIR=.*$/, "DIR=#{prefix}"

    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    system "make", "install", "PREFIX=#{prefix}"

    %w[bench cli dump repair server].each do |suffix|
      bin.install "#{prefix}/ssdb-#{suffix}"
    end

    ["run", "db/ssdb", "db/ssdb_slave", "log"].each do |dir|
      (var/dir).mkpath
    end

    inreplace "ssdb.conf" do |s|
      s.gsub! "work_dir = ./var", "work_dir = #{var}/db/ssdb/"
      s.gsub! "pidfile = ./var/ssdb.pid", "pidfile = #{var}/run/ssdb.pid"
      s.gsub! "\toutput: log.txt", "\toutput: #{var}/log/ssdb.log"
    end

    inreplace "ssdb_slave.conf" do |s|
      s.gsub! "work_dir = ./var_slave", "work_dir = #{var}/db/ssdb_slave/"
      s.gsub! "pidfile = ./var_slave/ssdb.pid", "pidfile = #{var}/run/ssdb_slave.pid"
      s.gsub! "\toutput: log_slave.txt", "\toutput: #{var}/log/ssdb_slave.log"
    end

    etc.install "ssdb.conf"
    etc.install "ssdb_slave.conf"
  end

  plist_options :manual => "ssdb-server #{HOMEBREW_PREFIX}/etc/ssdb.conf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/ssdb-server</string>
          <string>#{etc}/ssdb.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/ssdb.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/ssdb.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    pid = fork do
      Signal.trap("TERM") do
        system("#{bin}/ssdb-server -d #{HOMEBREW_PREFIX}/etc/ssdb.conf")
        exit
      end
    end
    sleep(3)
    Process.kill("TERM", pid)
  end
end
