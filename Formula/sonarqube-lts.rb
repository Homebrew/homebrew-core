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
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "790c3b1664d331817bf85ae9b99de3b960689085b9f7707ac424d73de6cee5c2"
  end

  depends_on "openjdk@11"

  conflicts_with "sonarqube", because: "both install the same binaries"

  def install
    # Delete native bin directories for other systems
    remove, keep = if OS.mac?
      ["linux", "macosx-universal"]
    else
      ["macosx", "linux-x86"]
    end

    rm_rf Dir["bin/{#{remove},windows}-*"]

    libexec.install Dir["*"]

    (bin/"sonar").write_env_script libexec/"bin/#{keep}-64/sonar.sh",
      Language::Java.overridable_java_home_env("11")
  end

  service do
    run [opt_bin/"sonar", "start"]
  end

  test do
    assert_match "SonarQube", shell_output("#{bin}/sonar status", 1)
  end
end
