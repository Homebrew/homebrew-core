class Rhino < Formula
  desc "JavaScript engine"
  homepage "https://www.mozilla.org/rhino/"
  url "https://github.com/mozilla/rhino/releases/download/Rhino1_7_13_Release/rhino-1.7.13.zip"
  sha256 "8531e0e0229140c80d743ece77ffda155d4eb3fa56cca4f36fbfba1088478b3e"
  license "MPL-2.0"

  livecheck do
    url "https://github.com/mozilla/rhino/releases/latest"
    regex(%r{href=.*?/tag/.*?>Rhino (\d+(?:\.\d+)+)<}i)
  end

  bottle :unneeded

  conflicts_with "nut", because: "both install `rhino` binaries"

  def install
    rhino_jar = "rhino-#{version}.jar"
    libexec.install "lib/#{rhino_jar}"
    bin.write_jar_script libexec/rhino_jar, "rhino"
    doc.install Dir["docs/*"]
  end

  test do
    assert_equal "42", shell_output("#{bin}/rhino -e \"print(6*7)\"").chomp
  end
end
