class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://search.maven.org/remotecontent?filepath=org/gridkit/jvmtool/sjk-plus/0.20/sjk-plus-0.20.jar"
  sha256 "c10aeb794137aebc1f38de0a627aaed270fc545026de216d36b8befb6c31d860"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "94b4054e1a1ad665cfc6ed8701d2b02746dfb1f099a2a688a2b945ec664c1575"
    sha256 cellar: :any_skip_relocation, big_sur:       "94b4054e1a1ad665cfc6ed8701d2b02746dfb1f099a2a688a2b945ec664c1575"
    sha256 cellar: :any_skip_relocation, catalina:      "94b4054e1a1ad665cfc6ed8701d2b02746dfb1f099a2a688a2b945ec664c1575"
    sha256 cellar: :any_skip_relocation, mojave:        "94b4054e1a1ad665cfc6ed8701d2b02746dfb1f099a2a688a2b945ec664c1575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51d29b3fd8b210d7dbd7d881ab0dda3aa40b99c99362f5ed3aa8c2a1de5b7d54"
    sha256 cellar: :any_skip_relocation, all:           "ce4c75268949b89a47d762e67ccbefdf55a8685188edb27f1827f58ebddc4a6e"
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
