class Ssdb < Formula
  desc "NoSQL database supporting many data structures: Redis alternative"
  homepage "http://ssdb.io/"
  url "https://github.com/ideawu/ssdb/archive/1.9.7.tar.gz"
  sha256 "ef7c1c048c48671b039fee4c557bcd0150cbab8f3814fdfb782b7aeec9f071ec"
  license "BSD-3-Clause"
  head "https://github.com/ideawu/ssdb.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "648dad2645bc14dcc8aed45a6345d6a691a816d30aaf36848912807b3d2923e3" => :catalina
    sha256 "b6d12c008d3b1b1b74dc149f78984039ffcdccdb30a4bf4b7d43960c02a121e0" => :mojave
    sha256 "a09b9360d1cae859fdc035dab88b4f58e6c495fb428457e470fb37cecdaeee01" => :high_sierra
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

  plist_options manual: "ssdb-server #{HOMEBREW_PREFIX}/etc/ssdb.conf"

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
        system("#{bin}/ssdb-server", "-d", "#{HOMEBREW_PREFIX}/etc/ssdb.conf")
        exit
      end
    end
    sleep(3)
    Process.kill("TERM", pid)
  end
end
