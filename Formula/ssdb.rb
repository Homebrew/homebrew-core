class Ssdb < Formula
  desc "NoSQL database supporting many data structures: Redis alternative"
  homepage "http://ssdb.io/"
  url "https://github.com/ideawu/ssdb/archive/1.9.9.tar.gz"
  sha256 "28b5b6505a6a660b587b7d07ef77a3983a0696f7d481aa70696e53048fa92e45"
  license "BSD-3-Clause"
  head "https://github.com/ideawu/ssdb.git"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "fd9b492537642a493ee437e27659b605336a5b0be915feba2894e6cdf2479c70"
    sha256 cellar: :any_skip_relocation, mojave:      "07653a68e92db84536be2a515051dd951c73a46a549532aebdac94dfd4d9028d"
    sha256 cellar: :any_skip_relocation, high_sierra: "63544af42f2779d149b1ca647d22fc1ce687ed68347ea689df8d8a52d3a72727"
  end

  depends_on "autoconf" => :build

  # Fix ssdb 1.9.9 build
  patch do
    url "https://github.com/chenrui333/ssdb/commit/9556a38fb1e3cb4920e2b6ab242183a747d55a51.patch?full_index=1"
    sha256 "ee765e6c98c991c0cf069a5bf4b0d571987b0fa35be756b5a8960190f1d14be9"
  end

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
