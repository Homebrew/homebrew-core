class Rhino < Formula
  desc "JavaScript engine"
  homepage "https://mozilla.github.io/rhino/"
  url "https://repo.maven.apache.org/maven2/org/mozilla/rhino-all/1.9.2/rhino-all-1.9.2.jar"
  sha256 "9b4fc23fdd7902beabd542099b6f590f05638dbbb054e9784f444982a6296493"
  license "MPL-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/mozilla/rhino/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71eea8e5a7f7a45cd2e7a16feef2fc368b1b3105d7970068ce3172d4a1d89058"
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
