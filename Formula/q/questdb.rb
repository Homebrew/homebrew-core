class Questdb < Formula
  desc "Time Series Database"
  homepage "https://questdb.io"
  url "https://github.com/questdb/questdb/releases/download/9.2.2/questdb-9.2.2-no-jre-bin.tar.gz"
  sha256 "27edc2e08c4cf92319a12753be933ccb595f4ed03d21b6ef527c860565fe181d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ac3e1c5eb793ae70ca838bb96b852d89c8f3c7eec0b2068676f5c5198561aa1c"
  end

  depends_on "openjdk"

  def install
    rm_r("questdb.exe")
    libexec.install Dir["*"]
    (bin/"questdb").write_env_script libexec/"questdb.sh", Language::Java.overridable_java_home_env
    inreplace libexec/"questdb.sh", "/usr/local/var/questdb", var/"questdb"

    # Make sure the var/questdb directory exists
    (var/"questdb").mkpath
  end

  service do
    run [opt_bin/"questdb", "start", "-d", var/"questdb", "-n", "-f"]
    keep_alive successful_exit: false
    error_log_path var/"log/questdb.log"
    log_path var/"log/questdb.log"
    working_dir var/"questdb"
  end

  test do
    # questdb.sh uses `ps | grep` to verify server is running, but output is truncated to COLUMNS
    # See https://github.com/Homebrew/homebrew-core/pull/133887#issuecomment-1679907729
    ENV.delete "COLUMNS" if OS.linux?

    mkdir_p testpath/"data"
    begin
      fork do
        exec bin/"questdb", "start", "-d", testpath/"data"
      end
      sleep 30
      output = shell_output("curl -Is localhost:9000/index.html")
      sleep 8
      assert_match "questDB", output
    ensure
      system bin/"questdb", "stop"
    end
  end
end
