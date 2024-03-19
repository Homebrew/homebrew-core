class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-4.1.0.tar.gz"
  sha256 "70728473612a26575df894220f160a431100ed6fb974959396aaec1d90808aa1"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_sonoma:   "6ca02b460bab1f3673e79af57e9f66ece8d10c9c1e243dc8bf766323502c7842"
    sha256 arm64_ventura:  "b87518aef606352faf6f11bd2babf7d4d53d1680cda662a5d01da01a7e8b09f7"
    sha256 arm64_monterey: "0c560016ab274eb107081ad91c53866cf96ecf8385be46d368d9d35b5fbdf730"
    sha256 sonoma:         "88b9ec5ce39b54cd42af6012147284a9826e5e484285713aa4434fd86601d802"
    sha256 ventura:        "5b3cb5ef6d8380651cf506056a665573a3f70c085c06cd8de39fd93f5b57d85c"
    sha256 monterey:       "aaa0e65bbabddf39c91084d04c57e3bcf37d4df38d31d254047a65b95907bd40"
    sha256 x86_64_linux:   "73e9c4c4bd083d502d813ac13eadb46aa315a2b64b2ebdedee86c92c1c6f0b25"
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
