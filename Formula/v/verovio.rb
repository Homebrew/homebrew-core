class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-5.0.0.tar.gz"
  sha256 "3b64d3002f7ddf728d6e9a9782618a88341ff900f65fa3181b435251e9537314"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_sequoia: "7dfc82a1128362e9d374445f2484f3716e849ac972e8cc4e06029117fb760d83"
    sha256 arm64_sonoma:  "7d8e58036363a410e22d04dac8fc4d8012d87734b5919febb3bab0a9417f5c7b"
    sha256 arm64_ventura: "33af995f18d1ce2dc29e2ac40441de035c45f4e25a8688db97db52ffaf5d502d"
    sha256 sonoma:        "033bdfc9a3d91580b62d95aa1327480af7008a36815bbc4c421b29284374eb02"
    sha256 ventura:       "9f42a22bb93be8ea6f8becf920cd3de117f6f6b08451547834b19cb80222221a"
    sha256 x86_64_linux:  "80617595df50e81d38f0ab6d4c35a82c99034d6f4b89f03383faccd566b064c3"
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
    assert_path_exists testpath/"output.svg"
  end
end
