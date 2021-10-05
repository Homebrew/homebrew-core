class Questdb < Formula
  desc "Time Series Database"
  homepage "https://questdb.io"
  url "https://github.com/questdb/questdb/releases/download/6.0.7.1/questdb-6.0.7.1-no-jre-bin.tar.gz"
  sha256 "b399dc70cc4bc32b48af4ba05d78ba8a01e5839a53c28a0284b6c580a08b6371"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3c825c1f93fb5866ba934d8514bdb42b73e7aed657b17c0a95facfce4f8149f8"
    sha256 cellar: :any_skip_relocation, big_sur:       "89effa1916fe5d8dfc2afbfdf0aa1d3b15da95d147e6f26b51db37c6423c78ee"
    sha256 cellar: :any_skip_relocation, catalina:      "89effa1916fe5d8dfc2afbfdf0aa1d3b15da95d147e6f26b51db37c6423c78ee"
    sha256 cellar: :any_skip_relocation, mojave:        "89effa1916fe5d8dfc2afbfdf0aa1d3b15da95d147e6f26b51db37c6423c78ee"
  end

  depends_on "openjdk@11"

  def install
    rm_rf "questdb.exe"
    libexec.install Dir["*"]
    (bin/"questdb").write_env_script libexec/"questdb.sh", Language::Java.overridable_java_home_env("11")
  end

  service do
    run [opt_bin/"questdb", "start", "-d", "var/\"questdb\"", "-n", "-f"]
    working_dir var/"questdb"
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
