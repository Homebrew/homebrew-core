class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.9.5.zip"
  sha256 "c7f182c4fc19e8ab5aac1ff5a0107044bde00205ec5f57fad47a5fe967509411"
  license "LGPL-3.0-or-later"

  # The regex below should only match the LTS release archive on the Sonarqube
  # downloads page. This is necessary because the usual index page for releases
  # doesn't distinguish between current and LTS releases.
  livecheck do
    url "https://www.sonarqube.org/downloads/"
    regex(/downloads-lts.+?href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.(?:zip|t)/im)
  end

  bottle :unneeded

  depends_on "openjdk"

  conflicts_with "sonarqube", because: "both install the same binaries"

  def install
    # Delete native bin directories for other systems
    rm_rf Dir["bin/{linux,windows}-*"]

    libexec.install Dir["*"]

    (bin/"sonar").write_env_script libexec/"bin/macosx-universal-64/sonar.sh",
      JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  plist_options manual: "sonar console"

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
