class Ssdb < Formula
  desc "NoSQL database supporting many data structures: Redis alternative"
  homepage "https://ssdb.io/"
  url "https://github.com/ideawu/ssdb/archive/1.9.9.tar.gz"
  sha256 "a32009950114984d6e468e10d964b0ef1e846077b69d7c7615715fdfa01aaf6e"
  license "BSD-3-Clause"
  head "https://github.com/ideawu/ssdb.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, monterey:     "5251016f1ba03a184424fc041e61501398577ca0c1aceac23748e22bc8883f5f"
    sha256 cellar: :any_skip_relocation, big_sur:      "f92e221d20ca1a85c7ae555acd1417bba60b208a56091eb3a25d98fc788f25a3"
    sha256 cellar: :any_skip_relocation, catalina:     "4253e51c8e447b5d4e0ec5f064ee2fcc3ef57b30734df70f3b24d6399abb9363"
    sha256 cellar: :any_skip_relocation, mojave:       "a10edecc28880cd37e02e75fdc318392ba6bda016f624181a9f4ff10982b211f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9db77a02bd8c3ed9569919f579d4e3a3d434bfba9f4679aafbc3c2de87993478"
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

  service do
    run [opt_bin/"ssdb-server", etc/"ssdb.conf"]
    keep_alive successful_exit: false
    error_log_path var/"log/ssdb.log"
    log_path var/"log/ssdb.log"
    working_dir var
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
