class Questdb < Formula
  desc "Time Series Database"
  homepage "https://questdb.io"
  url "https://github.com/questdb/questdb/releases/download/6.1.3/questdb-6.1.3-no-jre-bin.tar.gz"
  sha256 "3d1c7031c0fd80560597f8ce64cbc6cd8a3097e80f7cfb94581189bdc5d04834"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9908f2c8a813b11f53ca3f27e41329b4c7ac956002707279deda12ca7f5d95b8"
    sha256 cellar: :any_skip_relocation, big_sur:       "f7f385dbcecc4fddfdecc2f604f8b4ce9d94c508d5d0b549f1d5662acf273b03"
    sha256 cellar: :any_skip_relocation, catalina:      "f7f385dbcecc4fddfdecc2f604f8b4ce9d94c508d5d0b549f1d5662acf273b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9908f2c8a813b11f53ca3f27e41329b4c7ac956002707279deda12ca7f5d95b8"
  end

  depends_on "openjdk@11"

  def install
    rm_rf "questdb.exe"
    libexec.install Dir["*"]
    (bin/"questdb").write_env_script libexec/"questdb.sh", Language::Java.overridable_java_home_env("11")
  end

  service do
    run [opt_bin/"questdb", "start", "-d", var/"questdb", "-n", "-f"]
    keep_alive true
    working_dir var/"questdb"
    log_path var/"log/questdb.log"
    error_log_path var/"log/questdb.log"
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
