class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.9.3.zip"
  sha256 "151ca73046bd788b68fbaefe362af2862565fdb0cdfae715a669539a725808fd"

  bottle :unneeded

  depends_on "openjdk"

  conflicts_with "sonarqube", :because => "both install the same binaries"

  def install
    # Delete native bin directories for other systems
    rm_rf Dir["bin/{linux,windows}-*"]

    libexec.install Dir["*"]

    (bin/"sonar").write_env_script libexec/"bin/macosx-universal-64/sonar.sh",
      :JAVA_HOME => Formula["openjdk"].opt_prefix
  end

  plist_options :manual => "sonar console"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
          <string>#{opt_bin}/sonar</string>
          <string>start</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match "SonarQube", shell_output("#{bin}/sonar status", 1)
  end
end
