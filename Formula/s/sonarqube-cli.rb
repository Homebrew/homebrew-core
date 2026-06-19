class SonarqubeCli < Formula
  desc "Code quality and security analysis for your terminal, scripts, and AI agents"
  homepage "https://sonarsource.com/sonarqube/cli/"
  url "https://github.com/SonarSource/sonarqube-cli/archive/refs/tags/1.1.0.3122.tar.gz"
  sha256 "80ef512c1c3dcb97b2a6ef8db08c1eca466576eb7ee491520a580c11346d8375"
  license "LGPL-3.0-or-later"

  depends_on "bun" => :build

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on "icu4c@78"
  end

  def install
    inreplace "bun.lock",
              "https://repox.jfrog.io/artifactory/api/npm/npm/",
              "https://registry.npmjs.org/"
    inreplace "package.json",
              '"prepare": "husky"',
              '"prepare": "true"'

    system "bun", "install", "--production", "--frozen-lockfile",
           "--registry=https://registry.npmjs.org"

    with_env "SONARQUBE_CLI_DISTRIBUTION" => "homebrew" do
      system "bun", "build-scripts/build-binary.ts"
    end

    bin.install "dist/sonarqube-cli" => "sonar"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    ENV["SONAR_USER_HOME"] = testpath

    output = shell_output("#{bin}/sonar auth status 2>&1", 1)
    assert_match "No saved connection", output
  end
end
