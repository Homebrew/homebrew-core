class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://search.maven.org/remotecontent?filepath=org/gridkit/jvmtool/sjk-plus/0.16/sjk-plus-0.16.jar"
  sha256 "306c40fbf76b9cb9a09b394116b8a2614b0d9acb3725e845d2a754686a6d3d49"
  license "Apache-2.0"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "sjk-plus-#{version}.jar"
    bin.write_jar_script libexec/"sjk-plus-#{version}.jar", "sjk"
  end

  test do
    system bin/"sjk", "jps"
  end
end
