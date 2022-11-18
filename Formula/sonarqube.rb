class Sonarqube < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.7.1.62043.zip"
  sha256 "d3e5d6f36f7a1f0f08d5df2936a9d1d5f962a7a65d980e533e5576482c529e91"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarqube.org/success-download-community-edition/"
    regex(/href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c925ddc78555813a51b084ff9f9d355485ce37e7f4044798fe3942033e6cc5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c925ddc78555813a51b084ff9f9d355485ce37e7f4044798fe3942033e6cc5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c925ddc78555813a51b084ff9f9d355485ce37e7f4044798fe3942033e6cc5c"
    sha256 cellar: :any_skip_relocation, ventura:        "95e45378010f0db53e5969163cfe98fb29b882b1816b5405ff1f1b136c8fdac3"
    sha256 cellar: :any_skip_relocation, monterey:       "95e45378010f0db53e5969163cfe98fb29b882b1816b5405ff1f1b136c8fdac3"
    sha256 cellar: :any_skip_relocation, big_sur:        "95e45378010f0db53e5969163cfe98fb29b882b1816b5405ff1f1b136c8fdac3"
    sha256 cellar: :any_skip_relocation, catalina:       "95e45378010f0db53e5969163cfe98fb29b882b1816b5405ff1f1b136c8fdac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8da593a6fd235fe6970a2d8c227aec44a2327eea3fb55f0c8aeb2d88949e528f"
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
