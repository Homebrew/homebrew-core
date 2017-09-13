class Rhino < Formula
  desc "JavaScript engine"
  homepage "https://www.mozilla.org/rhino/"
  url "https://github.com/mozilla/rhino/releases/download/Rhino1_7_7_2_Release/rhino-1.7.7.2.zip",
      :using => :nounzip
  sha256 "20b5736a2e596cf9367266dc749791f590838e5236b6bd2d21d582a560b33c4d"

  bottle :unneeded

  conflicts_with "nut", :because => "both install `rhino` binaries"

  def install
    # zip file contains duplicates
    # Reported 1 Sep 2017 https://github.com/mozilla/rhino/issues/321
    system "unzip", "-qqo", "rhino-#{version}.zip"
    cd "rhino#{version}"

    rhino_jar = "rhino-#{version}.jar"
    libexec.install "lib/#{rhino_jar}"
    bin.write_jar_script libexec/rhino_jar, "rhino"
    doc.install Dir["docs/*"]
  end

  test do
    assert_equal "42", shell_output("#{bin}/rhino -e \"print(6*7)\"").chomp
  end
end
