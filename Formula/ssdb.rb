class Ssdb < Formula
  desc "NoSQL database supporting many data structures: Redis alternative"
  homepage "http://ssdb.io/"
  url "https://github.com/ideawu/ssdb/archive/1.9.7.tar.gz"
  sha256 "ef7c1c048c48671b039fee4c557bcd0150cbab8f3814fdfb782b7aeec9f071ec"
  head "https://github.com/ideawu/ssdb.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "adc9b1c421a96f617d53eb9b2750730a2f94470b96bbbffd42171034b42f50e3" => :catalina
    sha256 "17baf0ab0b2d11d987ff8bf3b9de6a19bf6839a4b23bcd76d01a0d62421141d9" => :mojave
    sha256 "5ab4ecd6c2d2df8996fc71477e4abe970a48b53999ddc291ceeb06b261ae21d0" => :high_sierra
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

  def plist
    <<~EOS
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
