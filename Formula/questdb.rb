class Questdb < Formula
  desc "Time Series Database"
  homepage "https://questdb.io"
  url "https://github.com/questdb/questdb/releases/download/7.1.2/questdb-7.1.2-no-jre-bin.tar.gz"
  sha256 "c099c3caf016426c3b3fdcb944b8742c6689dd7eb8d720bab034490c20fcd25a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b19c9507b39da62fe82f6029eafb892e647239501dc4e23ce91837e08137178"
  end

  depends_on "openjdk@17"

  def install
    rm_rf "questdb.exe"
    libexec.install Dir["*"]
    (bin/"questdb").write_env_script libexec/"questdb.sh", Language::Java.overridable_java_home_env("17")
    inreplace libexec/"questdb.sh", "/usr/local/var/questdb", var/"questdb"
  end

  def post_install
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
    mkdir_p testpath/"data"
    port = free_port
    ENV["QDB_HTTP_BIND_TO"] = "127.0.0.1:#{port}"
    begin
      fork do
        exec "#{bin}/questdb start -d #{testpath}/data"
      end
      sleep 40
      output = shell_output("curl -Is 127.0.0.1:#{port}/index.html")
      sleep 4
      assert_match "questDB", output
    ensure
      system "#{bin}/questdb", "stop"
    end
  end
end
