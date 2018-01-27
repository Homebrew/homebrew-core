class Sonarlint < Formula
  desc "Provides pre-commit feedback on quality issues injected into code"
  homepage "https://github.com/SonarSource/sonarlint-cli"
  url "https://bintray.com/sonarsource/Distribution/download_file?file_path=sonarlint-cli%2Fsonarlint-cli-2.1.0.566.zip"
  sha256 "75320a0629f3f7b83ccaa4098ccbbb8decedc518a1b8fc2503f753266dc71d70"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat"]

    libexec.install Dir["*"]

    bin.write_exec_script libexec/"bin/sonarlint"
  end

  test do
    system "#{bin}/sonarlint", "--version"
  end
end
