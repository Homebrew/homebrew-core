class Sonarlint < Formula
  desc "provides pre-commit feedback on quality issues injected into code."
  homepage "http://www.sonarlint.org/commandline/index.html"
  url "https://bintray.com/sonarsource/Distribution/download_file?file_path=sonarlint-cli%2Fsonarlint-cli-2.0.zip"
  sha256 "dafbaba032330f898e0f750f80ac212260cf825070dced1c2376c07c9d34c007"

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
