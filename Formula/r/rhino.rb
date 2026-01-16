class Rhino < Formula
  desc "JavaScript engine"
  homepage "https://mozilla.github.io/rhino/"
  url "https://repo.maven.apache.org/maven2/org/mozilla/rhino-all/1.9.0/rhino-all-1.9.0.jar"
  sha256 "caafa887e3b32efa74f1aac9984f0f54e733ff5a0ea62b057861c053a6619328"
  license "MPL-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/mozilla/rhino/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "63429751c09f95844bfb126b19a9e3dac45ad791c2c7772a4f059d7942c36f3b"
  end

  depends_on "openjdk@21"

  conflicts_with "nut", because: "both install `rhino` binaries"

  def install
    libexec.install "rhino-all-#{version}.jar" => "rhino.jar"
    bin.write_jar_script libexec/"rhino.jar", "rhino", java_version: "21"
  end

  test do
    assert_equal "42", shell_output("#{bin}/rhino -e \"print(6*7)\"").chomp
  end
end
