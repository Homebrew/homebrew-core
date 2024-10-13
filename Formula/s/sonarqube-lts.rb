class SonarqubeLts < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.7.96285.zip"
  sha256 "82eb93a1380dac4725ad24fd94a11917fb2e0ac6b9a9c98b20e436ed2a50f351"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://www.sonarsource.com/page-data/products/sonarqube/downloads/page-data.json"
    regex(/SonarQube\s+v?\d+(?:\.\d+)+\s+LT[AS].*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df554724c5b9f1dd155b25910662f7fec4b9c3d5c80109b324a83db7ee591885"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df554724c5b9f1dd155b25910662f7fec4b9c3d5c80109b324a83db7ee591885"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df554724c5b9f1dd155b25910662f7fec4b9c3d5c80109b324a83db7ee591885"
    sha256 cellar: :any_skip_relocation, sonoma:        "df554724c5b9f1dd155b25910662f7fec4b9c3d5c80109b324a83db7ee591885"
    sha256 cellar: :any_skip_relocation, ventura:       "df554724c5b9f1dd155b25910662f7fec4b9c3d5c80109b324a83db7ee591885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d88fe51f712ae92afc9d01a408d93aa8075fd47ed794dc166b7addc361686f9"
  end

  depends_on "openjdk@17"

  conflicts_with "sonarqube", because: "both install the same binaries"

  def install
    # Delete native bin directories for other systems
    remove, keep = if OS.mac?
      ["linux", "macosx-universal"]
    else
      ["macosx", "linux-x86"]
    end

    rm_r(Dir["bin/{#{remove},windows}-*"])

    libexec.install Dir["*"]

    (bin/"sonar").write_env_script libexec/"bin/#{keep}-64/sonar.sh",
      Language::Java.overridable_java_home_env("17")
  end

  service do
    run [opt_bin/"sonar", "start"]
  end

  test do
    ENV["SONAR_JAVA_PATH"] = Formula["openjdk@17"].opt_bin/"java"
    assert_match "SonarQube", shell_output("#{bin}/sonar status", 1)
  end
end
