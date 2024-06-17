class Rhino < Formula
  desc "JavaScript engine"
  homepage "https://mozilla.github.io/rhino/"
  url "https://github.com/mozilla/rhino/releases/download/Rhino1_7_15_Release/rhino-1.7.15.zip"
  sha256 "42fce6baf1bf789b62bf938b8e8ec18a1ac92c989dd6e7221e9531454cbd97fa"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^(?:Rhino[._-]?)v?(\d+(?:[._]\d+)+)[._-]Release$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "50d816e647a67bc75f5baa56dfa4609f14d01b1622eee1f4926f12f45ddf476e"
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
