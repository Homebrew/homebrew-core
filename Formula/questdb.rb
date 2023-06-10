class Questdb < Formula
  desc "Time Series Database"
  homepage "https://questdb.io"
  url "https://github.com/questdb/questdb/releases/download/7.2/questdb-7.2-no-jre-bin.tar.gz"
  sha256 "dfba6635e374dac1edd82a728e4dc5a4116c701c3666a9b89cd98e972897e87d"
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
    begin
      fork do
        exec "#{bin}/questdb start -d #{testpath}/data"
      end
      sleep 30
      output = shell_output("curl -Is localhost:9000/index.html")
      sleep 4
      assert_match "questDB", output
    ensure
      system "#{bin}/questdb", "stop"
      sleep 4
    end
  end
end
