class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://search.maven.org/remotecontent?filepath=org/gridkit/jvmtool/sjk-plus/0.7/sjk-plus-0.7.jar"
  sha256 "9f057f58837f1440ac91cdd106ac550c30c731104969b32d0b9f3f41f0174b13"

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
