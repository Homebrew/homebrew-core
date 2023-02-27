class Questdb < Formula
  desc "Time Series Database"
  homepage "https://questdb.io"
  url "https://github.com/questdb/questdb/releases/download/7.0.1/questdb-7.0.1-no-jre-bin.tar.gz"
  sha256 "90a20542d6fe48dc8b6eada80d375e951d8a47c1c0b4f774759157eafdf64616"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5a3045e1a6a9ba67e0e8bcff5cc259f06f2f1603dcd2dd3871b1602e60624d33"
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
    end
  end
end
