class Sonarqube < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.4.0.54424.zip"
  sha256 "df8d97ae93002593fcaceacfe4dfdab68982a8dc52002c441ee6218f4d71961c"
  license "LGPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://www.sonarqube.org/success-download-community-edition/"
    regex(/href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46547b82e1821d1a2fdd3d340d14aed54710705ff4a00f948fef8cb56187203f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46547b82e1821d1a2fdd3d340d14aed54710705ff4a00f948fef8cb56187203f"
    sha256 cellar: :any_skip_relocation, monterey:       "7b9522ce8f801fc37e8b5ba585670ce484cfc34c89e8483a83936eb2dd95f3f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b9522ce8f801fc37e8b5ba585670ce484cfc34c89e8483a83936eb2dd95f3f6"
    sha256 cellar: :any_skip_relocation, catalina:       "7b9522ce8f801fc37e8b5ba585670ce484cfc34c89e8483a83936eb2dd95f3f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f83ab713cba4041c8d08cf2c6cf1d79319ac72cab34f4b675e5218668083d69c"
  end

  depends_on "java-service-wrapper"
  depends_on "openjdk@11"

  conflicts_with "sonarqube-lts", because: "both install the same binaries"

  def install
    # Delete older packaged java-service-wrapper
    wrapper_version = "3.2.3"
    buildpath.glob("bin/*-64").map(&:rmtree)
    (buildpath/"lib/jsw/wrapper-#{wrapper_version}.jar").unlink

    platform = OS.mac? ? "macosx-universal-64" : "linux-x86-64"
    platform_bin = buildpath/"bin"/platform
    (platform_bin/"lib").mkpath

    # Link newer java-service-wrapper formula which is Apple Silicon compatible
    jsw_libexec = Formula["java-service-wrapper"].opt_libexec
    ln_s jsw_libexec/"lib/wrapper.jar", buildpath/"lib/jsw/wrapper.jar"
    ln_s jsw_libexec/"lib"/shared_library("libwrapper"), platform_bin/"lib/"
    ln_s jsw_libexec/"bin/wrapper", platform_bin/"wrapper"

    # Create new sonar.sh script and update conf files
    cp jsw_libexec/"scripts/App.sh.in", platform_bin/"sonar.sh"
    chmod 0755, platform_bin/"sonar.sh"
    inreplace platform_bin/"sonar.sh" do |s|
      s.gsub! "@app.name@", "SonarQube"
      s.gsub! "@app.long.name@", "SonarQube"
      s.gsub! "../conf/wrapper.conf", "../../conf/wrapper.conf"
      # Write PID file outside of installation directory
      s.sub!(/^PIDDIR="\."$/, "PIDDIR=#{var}/run")
    end
    inreplace "conf/wrapper.conf" do |s|
      s.gsub! "wrapper-#{wrapper_version}.jar", "wrapper.jar"
      # Set wrapper.working.dir to allow using symlinked wrapper
      s.sub!(/^wrapper\.java\.command=.*/, "\\0\nwrapper.working.dir=#{libexec}/bin/#{platform}")
      # Write log files outside of installation directory
      s.sub! %r{^wrapper\.logfile=.*/([^/\s]+\.log)$}, "wrapper.logfile=#{var}/sonarqube/logs/\\1"
    end
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
      assert_match(/SonarQube.* is running:.* Wrapper:STARTED, Java:STARTED/, output)
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
