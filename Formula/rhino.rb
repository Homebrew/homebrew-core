class Rhino < Formula
  desc "JavaScript engine"
  homepage "https://www.mozilla.org/rhino/"
  url "https://github.com/mozilla/rhino/releases/download/Rhino1_7_7_1_RELEASE/rhino-1.7.7.1.zip"
  sha256 "f753d82002927208139f374e47febb35d7832a10890f57bb1a3c28cad0de6e84"

  bottle :unneeded

  conflicts_with "nut", :because => "both install `rhino` binaries"

  def install
    rhino_jar = "rhino-#{version}.jar"
    libexec.install "lib/#{rhino_jar}"
    bin.write_jar_script libexec/rhino_jar, "rhino"
    doc.install (buildpath/"docs").children
  end

  test do
    assert_equal "42", shell_output("#{bin}/rhino -e \"print(6*7)\"").chomp
  end
end
