class Rhino < Formula
  desc "JavaScript engine"
  homepage "https://mozilla.github.io/rhino/"
  url "https://repo.maven.apache.org/maven2/org/mozilla/rhino-all/1.8.0/rhino-all-1.8.0.jar"
  sha256 "a67bc8555c36236fc7eac7042f4083d7cb9eba239a2ed06f68d07af885ada33c"
  license "MPL-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/mozilla/rhino/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "88bec579e89f74a217422bbaeffa61ad5e85125583cb9722f51e42509ccdad12"
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
