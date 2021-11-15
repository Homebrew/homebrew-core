class Rhino < Formula
  desc "JavaScript engine"
  homepage "https://www.mozilla.org/rhino/"
  url "https://github.com/mozilla/rhino/releases/download/Rhino1_7_13_Release/rhino-1.7.13.zip"
  sha256 "8531e0e0229140c80d743ece77ffda155d4eb3fa56cca4f36fbfba1088478b3e"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^(?:Rhino[._-]?)v?(\d+(?:[._]\d+)+)[._-]Release$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ee2cee36979875331df35909efc3757c8734e540f6ed82f8449193d8579587d"
  end

  depends_on "openjdk@11"

  conflicts_with "nut", because: "both install `rhino` binaries"

  def install
    rhino_jar = "rhino-#{version}.jar"
    libexec.install "lib/#{rhino_jar}"
    bin.write_jar_script libexec/rhino_jar, "rhino", java_version: "11"
    doc.install Dir["docs/*"]
  end

  test do
    assert_equal "42", shell_output("#{bin}/rhino -e \"print(6*7)\"").chomp
  end
end
