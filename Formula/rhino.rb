class Rhino < Formula
  desc "JavaScript engine"
  homepage "https://www.mozilla.org/rhino/"
  url "https://github.com/mozilla/rhino/releases/download/Rhino1_7_12_Release/rhino-1.7.12.zip"
  sha256 "59f074c3b2445381e4bb201eb65aa1e5f2afce021ebcad90003f32b480fbaaba"
  license "MPL-2.0"

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
