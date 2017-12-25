class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://search.maven.org/remotecontent?filepath=org/gridkit/jvmtool/sjk-plus/0.9/sjk-plus-0.9.jar"
  sha256 "3868290a0b379933d40e0ea0eac756de1b80f4c6db846f3c1c9b24799fcdc9bd"

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
