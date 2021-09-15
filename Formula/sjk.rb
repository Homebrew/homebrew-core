class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://search.maven.org/remotecontent?filepath=org/gridkit/jvmtool/sjk-plus/0.19/sjk-plus-0.19.jar"
  sha256 "f1504271eba4783473aade3e929df0049a380b0ed1aeb0c997ddc0506acbc912"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2bc1c9dadeff20643d36e42a6f018a80c6df288fa5e3bbaf557b611007142b14"
  end

  depends_on "openjdk"

  def install
    libexec.install "sjk-plus-#{version}.jar"
    bin.write_jar_script libexec/"sjk-plus-#{version}.jar", "sjk"
  end

  test do
    system bin/"sjk", "jps"
  end
end
