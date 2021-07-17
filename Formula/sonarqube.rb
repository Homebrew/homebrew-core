class Sonarqube < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.0.0.45539.zip"
  sha256 "b5a8a5330527515ddf34cbd4f6284b5ccec1d9c4384c46eb1786101ee7e2c065"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://binaries.sonarsource.com/Distribution/sonarqube/"
    regex(/href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3716b856b58caac1530583ece1e225f649aff630b076f6ac99c9441d27359058"
    sha256 cellar: :any_skip_relocation, big_sur:       "5b873ec61473422655a4ee25de3399e821dc0036d3c14ee55062639cdb324d1a"
    sha256 cellar: :any_skip_relocation, catalina:      "5b873ec61473422655a4ee25de3399e821dc0036d3c14ee55062639cdb324d1a"
    sha256 cellar: :any_skip_relocation, mojave:        "b241fd1293ab3dc9ba5a914f9cf374493ae3a7a245d8dc66e556f1d66cf88421"
  end

  depends_on "openjdk@11"

  conflicts_with "sonarqube-lts", because: "both install the same binaries"

  def install
    # Delete native bin directories for other systems
    rm_rf Dir["bin/{linux,windows}-*"]

    libexec.install Dir["*"]

    (bin/"sonar").write_env_script libexec/"bin/macosx-universal-64/sonar.sh",
      Language::Java.overridable_java_home_env("11")
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
