class Sonarqube < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.0.0.68432.zip"
  sha256 "e04bc9e78cad3f4137fb89b8527963d01587ed9a6fce4f4ac7b370fe21bac199"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/page-data.json"
    regex(/sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a06b3ae0b22ad47bb6f809666632730744b0cbc8567b8be2a8dbcb1ba88d9568"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a06b3ae0b22ad47bb6f809666632730744b0cbc8567b8be2a8dbcb1ba88d9568"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a06b3ae0b22ad47bb6f809666632730744b0cbc8567b8be2a8dbcb1ba88d9568"
    sha256 cellar: :any_skip_relocation, ventura:        "a06b3ae0b22ad47bb6f809666632730744b0cbc8567b8be2a8dbcb1ba88d9568"
    sha256 cellar: :any_skip_relocation, monterey:       "a06b3ae0b22ad47bb6f809666632730744b0cbc8567b8be2a8dbcb1ba88d9568"
    sha256 cellar: :any_skip_relocation, big_sur:        "a06b3ae0b22ad47bb6f809666632730744b0cbc8567b8be2a8dbcb1ba88d9568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebf2cc25e1802f84c5b06d6cf9d785e8ef0a13a83764be7dcca5073e34bd7739"
  end

  depends_on "openjdk@17"

  conflicts_with "sonarqube-lts", because: "both install the same binaries"

  def install
    platform = OS.mac? ? "macosx-universal-64" : "linux-x86-64"

    inreplace buildpath/"bin"/platform/"sonar.sh",
      %r{^PIDFILE="\./\$APP_NAME\.pid"$},
      "PIDFILE=#{var}/run/$APP_NAME.pid"

    inreplace "conf/sonar.properties" do |s|
      # Write log/data/temp files outside of installation directory
      s.sub!(/^#sonar\.path\.data=.*/, "sonar.path.data=#{var}/sonarqube/data")
      s.sub!(/^#sonar\.path\.logs=.*/, "sonar.path.logs=#{var}/sonarqube/logs")
      s.sub!(/^#sonar\.path\.temp=.*/, "sonar.path.temp=#{var}/sonarqube/temp")
    end

    libexec.install Dir["*"]
    env = Language::Java.overridable_java_home_env("17")
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
