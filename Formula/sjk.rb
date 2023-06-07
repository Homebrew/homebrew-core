class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://search.maven.org/remotecontent?filepath=org/gridkit/jvmtool/sjk-plus/0.21/sjk-plus-0.21.jar"
  sha256 "7f574af8d91a85bffa4ef8fa405abcb10acbbc53c01bd5e696909214a8f71267"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad0ceb71f9c1ed966e05b7ac8816579f0a7b72cc1cae547609533d1ab1a64f2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad0ceb71f9c1ed966e05b7ac8816579f0a7b72cc1cae547609533d1ab1a64f2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad0ceb71f9c1ed966e05b7ac8816579f0a7b72cc1cae547609533d1ab1a64f2e"
    sha256 cellar: :any_skip_relocation, ventura:        "ad0ceb71f9c1ed966e05b7ac8816579f0a7b72cc1cae547609533d1ab1a64f2e"
    sha256 cellar: :any_skip_relocation, monterey:       "ad0ceb71f9c1ed966e05b7ac8816579f0a7b72cc1cae547609533d1ab1a64f2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad0ceb71f9c1ed966e05b7ac8816579f0a7b72cc1cae547609533d1ab1a64f2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae7d27a086b25de39f9cc6cdeb402f7fc1fab711a23828cb7617c72b427de088"
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
