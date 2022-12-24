class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-3.14.0.tar.gz"
  sha256 "bbd65c80ac5a26062a1532342fa32fe05ecb7443cae820a26aa98a78a84c74b2"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_ventura:  "b57bfd2719ace6ddee54cb3db6ae0ff8deb69afb1a82ef0ffa86fccfe6233ed7"
    sha256 arm64_monterey: "43d721fbfa11d354501d0cfa5595d617e29ece168afe1fd58dcba315c83cdfed"
    sha256 arm64_big_sur:  "0e22e68bd215775e663eafb2a5129e6bd7ca3a810386d3efe33cda985d4f9c05"
    sha256 ventura:        "45bd279a16544b59f2c0285e3a24edfcb0fecbb7a10148915aaeb89ac0c2efcc"
    sha256 monterey:       "981e47320d3584e80c286d1e5ce76cf091415edbf11e879f526348f3de245723"
    sha256 big_sur:        "e1360ea1d7089d819cddd9a1646698f617b61ea1bdda746bbfd9773ad947bdc2"
    sha256 catalina:       "390919bae0cedc7d713e9dd8d97e5b50795d4d20cbacf9cd94c78f9f404dfce8"
    sha256 x86_64_linux:   "677db52651960347002aa4dec224107dbc5238050b8a47bf73e81433a826fe52"
  end

  depends_on "cmake" => :build

  resource "homebrew-testdata" do
    url "https://www.verovio.org/examples/downloads/Ahle_Jesu_meines_Herzens_Freud.mei"
    sha256 "79e6e062f7f0300e8f0f4364c4661835a0baffc3c1468504a555a5b3f9777cc9"
  end

  def install
    system "cmake", "-S", "./cmake", "-B", "tools", *std_cmake_args
    system "cmake", "--build", "tools"
    system "cmake", "--install", "tools"
  end

  test do
    system bin/"verovio", "--version"
    resource("homebrew-testdata").stage do
      shell_output("#{bin}/verovio Ahle_Jesu_meines_Herzens_Freud.mei -o #{testpath}/output.svg")
    end
    assert_predicate testpath/"output.svg", :exist?
  end
end
