class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://bintray.com/artifact/download/aragozin/generic/sjk-plus-0.4.2.jar"
  sha256 "5cc52746b6d150e0d1e990e9e4af51d14f56f1e8fe84443fb0da8b0be6c773ca"

  bottle :unneeded

  depends_on :java

  def install
    libexec.install "sjk-plus-#{version}.jar"
    bin.write_jar_script "#{libexec}/sjk-plus-#{version}.jar", "sjk"
  end

  test do
    system bin/"sjk", "jps"
  end
end
