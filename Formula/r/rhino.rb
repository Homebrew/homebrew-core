class Rhino < Formula
  desc "JavaScript engine"
  homepage "https://mozilla.github.io/rhino/"
  url "https://repo.maven.apache.org/maven2/org/mozilla/rhino-all/1.9.1/rhino-all-1.9.1.jar"
  sha256 "1cc2b468a51857747dcb29ae533e352a2abc04e81c5aa61e397dc774dd395329"
  license "MPL-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/mozilla/rhino/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "31d0c4e1e6a9316d307f3783f3151d949b6b16f1bc8446fb56579abb6f9662ee"
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
