class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.9.6.zip"
  sha256 "9991d4df42c10c181005df6a4aff6b342baf9be2f3ad0e83e52a502f44d2e2d8"
  license "LGPL-3.0-or-later"

  # Upstream doesn't distinguish LTS releases in the URL or filename, so this
  # only matches versions for the formula's current major/minor version. This
  # won't identify a new LTS version with a different major/minor but updating
  # the `stable` URL with the new LTS will fix the check until the next time.
  livecheck do
    url "https://binaries.sonarsource.com/Distribution/sonarqube/"
    regex(/href=.*?sonarqube[._-]v?(#{Regexp.escape(version.major_minor)}(?:\.\d+)*)\.zip/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cb7b43a7396102cfa85ab32e9647bf04ae88dfb5855104d52e664f71338cc9fc"
    sha256 cellar: :any_skip_relocation, big_sur:       "975d8370e016c2fd615699e67787c5ea2a00cd202ed6faa259964461a57384c5"
    sha256 cellar: :any_skip_relocation, catalina:      "975d8370e016c2fd615699e67787c5ea2a00cd202ed6faa259964461a57384c5"
    sha256 cellar: :any_skip_relocation, mojave:        "b4ffb6a083fc4eb59d55b9fc5ddaa95dce91408a6439f905c5d92a9c44be3b20"
  end

  depends_on "openjdk@11"

  conflicts_with "sonarqube", because: "both install the same binaries"

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
