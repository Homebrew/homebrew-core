class Sonarqube < Formula
  desc "Manage code quality"
  homepage "https://www.sonarsource.com/products/sonarqube/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.7.0.96327.zip"
  sha256 "4a5e5f0d7581e287cff4f02f7588dae499e2aa81fce37b88612acadfb4ba4518"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/success-download-community-edition/page-data.json"
    regex(/sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de22b2e0479df6d4d431bbc24a17f19b944b1dda3874842ea3d4845b4a3926c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de22b2e0479df6d4d431bbc24a17f19b944b1dda3874842ea3d4845b4a3926c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de22b2e0479df6d4d431bbc24a17f19b944b1dda3874842ea3d4845b4a3926c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "de22b2e0479df6d4d431bbc24a17f19b944b1dda3874842ea3d4845b4a3926c2"
    sha256 cellar: :any_skip_relocation, ventura:       "de22b2e0479df6d4d431bbc24a17f19b944b1dda3874842ea3d4845b4a3926c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1d4892c75139995b6b73e1538d1493acd4cb91856286a0c0b9a57afe1300860"
  end

  depends_on "openjdk@17"

  conflicts_with "sonarqube-lts", because: "both install the same binaries"

  def install
    inreplace "conf/sonar.properties" do |s|
      # Write log/data/temp files outside of installation directory
      s.sub!(/^#sonar\.path\.data=.*/, "sonar.path.data=#{var}/sonarqube/data")
      s.sub!(/^#sonar\.path\.logs=.*/, "sonar.path.logs=#{var}/sonarqube/logs")
      s.sub!(/^#sonar\.path\.temp=.*/, "sonar.path.temp=#{var}/sonarqube/temp")
    end

    libexec.install Dir["*"]
    (libexec/"extensions/downloads").mkpath

    env = Language::Java.overridable_java_home_env("17")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    env["PIDDIR"] = var/"run"
    platform = OS.mac? ? "macosx-universal-64" : "linux-x86-64"
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

    # Sonar uses `ps | grep` to verify server is running, but output is truncated to COLUMNS
    # See https://github.com/Homebrew/homebrew-core/pull/133887#issuecomment-1679907729
    ENV.delete "COLUMNS"

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
