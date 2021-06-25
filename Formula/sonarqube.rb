class Sonarqube < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.1.44547.zip"
  sha256 "f22d65a066848a4b7b7bfb255bc6f8c64c2a292718c09e23a1f7093f485ad00c"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://binaries.sonarsource.com/Distribution/sonarqube/"
    regex(/href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3dcee2d9de05efa6019ea3b84e2b5625f9408663b91fa23b6a4aab10abee52f4"
    sha256 cellar: :any_skip_relocation, big_sur:       "e7a9bee29eccc49d0743752a9aa98193de3f299e0f1d5f7727de020664957df0"
    sha256 cellar: :any_skip_relocation, catalina:      "e7a9bee29eccc49d0743752a9aa98193de3f299e0f1d5f7727de020664957df0"
    sha256 cellar: :any_skip_relocation, mojave:        "4c49c9acea99203b6595d05b3125b99fdc4e63e473d1ee5b21b0494c70a84890"
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
