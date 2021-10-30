class Sonarqube < Formula
  desc "Manage code quality"
  homepage "https://www.sonarqube.org/"
  url "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.2.0.49834.zip"
  sha256 "96aefddd3ec64d3ce73791755de780427165b2e8c6f25adb2510aaab8a567b75"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://binaries.sonarsource.com/Distribution/sonarqube/"
    regex(/href=.*?sonarqube[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "4ee7fd481ccb4301bb547fb7830ec7dd202959859c2404b753f5ed7ce02ca5aa"
    sha256 cellar: :any_skip_relocation, catalina:     "4ee7fd481ccb4301bb547fb7830ec7dd202959859c2404b753f5ed7ce02ca5aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5bd7b5e142d30a1caf30979e5e077f462e076540c514505d354df4625e2be67d"
  end

  # sonarqube ships pre-built x86_64 binaries
  depends_on "openjdk@11"

  conflicts_with "sonarqube-lts", because: "both install the same binaries"

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
    run [opt_bin/"sonar", "console"]
    keep_alive true
  end

  def caveats
    on_macos do
      <<~EOS
        Wrapper's native library are not yet available for Apple silicon.
        System signals will not be handled correctly on this architecture.
      EOS
    end
  end

  test do
    assert_match "SonarQube", shell_output("#{bin}/sonar status", 1)
  end
end
