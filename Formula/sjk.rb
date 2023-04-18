class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://search.maven.org/remotecontent?filepath=org/gridkit/jvmtool/sjk-plus/0.20/sjk-plus-0.20.jar"
  sha256 "c10aeb794137aebc1f38de0a627aaed270fc545026de216d36b8befb6c31d860"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce4c75268949b89a47d762e67ccbefdf55a8685188edb27f1827f58ebddc4a6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce4c75268949b89a47d762e67ccbefdf55a8685188edb27f1827f58ebddc4a6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce4c75268949b89a47d762e67ccbefdf55a8685188edb27f1827f58ebddc4a6e"
    sha256 cellar: :any_skip_relocation, ventura:        "ce4c75268949b89a47d762e67ccbefdf55a8685188edb27f1827f58ebddc4a6e"
    sha256 cellar: :any_skip_relocation, monterey:       "ce4c75268949b89a47d762e67ccbefdf55a8685188edb27f1827f58ebddc4a6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce4c75268949b89a47d762e67ccbefdf55a8685188edb27f1827f58ebddc4a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fea69e36de5ec022d12ae2f14d868fef4cfecb66fe339a698ca137cbcad21561"
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
