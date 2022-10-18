class Sonarqube < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.7.0.61563.zip"
  sha256 "c2c4c96d5da50ffbb806bff59c0211cf418c6446f87724bc8dc5e8005ef946bb"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarqube.org/success-download-community-edition/"
    regex(/href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac87c5da33c6c6abef8a53d2e646be52f6ccc5c3de6d856c0ca12ac2a865ce53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac87c5da33c6c6abef8a53d2e646be52f6ccc5c3de6d856c0ca12ac2a865ce53"
    sha256 cellar: :any_skip_relocation, monterey:       "80e9e61b9539bef70d1310be0619b444d89ed0ec1600b9131ab2b87fe6c2138c"
    sha256 cellar: :any_skip_relocation, big_sur:        "80e9e61b9539bef70d1310be0619b444d89ed0ec1600b9131ab2b87fe6c2138c"
    sha256 cellar: :any_skip_relocation, catalina:       "80e9e61b9539bef70d1310be0619b444d89ed0ec1600b9131ab2b87fe6c2138c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9f9b0ca1a9e978257c589963ec8b269f05ab44d813a1bb4812850764f534412"
  end

  depends_on "openjdk@11"

  conflicts_with "sonarqube-lts", because: "both install the same binaries"

  def install
    platform = OS.mac? ? "macosx-universal-64" : "linux-x86-64"

    inreplace buildpath/"bin"/platform/"sonar.sh",
      %r{^PIDFILE="\./\$APP_NAME\.pid"$},
      "PIDFILE=#{var}/run/\$APP_NAME.pid"

    inreplace "conf/sonar.properties" do |s|
      # Write log/data/temp files outside of installation directory
      s.sub!(/^#sonar\.path\.data=.*/, "sonar.path.data=#{var}/sonarqube/data")
      s.sub!(/^#sonar\.path\.logs=.*/, "sonar.path.logs=#{var}/sonarqube/logs")
      s.sub!(/^#sonar\.path\.temp=.*/, "sonar.path.temp=#{var}/sonarqube/temp")
    end

    libexec.install Dir["*"]
    env = Language::Java.overridable_java_home_env("11")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"sonar").write_env_script libexec/"bin"/platform/"sonar.sh", env
  end

  def post_install
    (var/"run").mkpath
    (var/"sonarqube/logs").mkpath
  end

  def caveats
    <<~EOS
      Data: #{var}/sonarqube/data
      Logs: #{var}/sonarqube/logs
      Temp: #{var}/sonarqube/temp
    EOS
  end

  service do
    run [opt_bin/"sonar", "console"]
    keep_alive true
  end

  test do
    port = free_port
    ENV["SONAR_WEB_PORT"] = port.to_s
    ENV["SONAR_EMBEDDEDDATABASE_PORT"] = free_port.to_s
    ENV["SONAR_SEARCH_PORT"] = free_port.to_s
    ENV["SONAR_PATH_DATA"] = testpath/"data"
    ENV["SONAR_PATH_LOGS"] = testpath/"logs"
    ENV["SONAR_PATH_TEMP"] = testpath/"temp"
    ENV["SONAR_TELEMETRY_ENABLE"] = "false"

    assert_match(/SonarQube.* is not running/, shell_output("#{bin}/sonar status", 1))
    pid = fork { exec bin/"sonar", "console" }
    begin
      sleep 15
      output = shell_output("#{bin}/sonar status")
      assert_match(/SonarQube is running \([0-9]*?\)/, output)
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
