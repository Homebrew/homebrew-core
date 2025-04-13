class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-5.1.0.tar.gz"
  sha256 "9c763112c31ed2cd49b9b406fc9437e0da2394f64c85f137a4e82c1e9c245d82"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_sequoia: "0cc3bc2dfc5201f8708e6ead89a91447b9f0ba1a8ea9c5e835903c46a5078b38"
    sha256 arm64_sonoma:  "67ee4411cf79d0b2827096ae9e31e554bd712b97a5637a446669bca0e4661e8c"
    sha256 arm64_ventura: "7dca5e82009385ca63e491d23838662dff936098c36cc1577fa8c2c1df6a62f6"
    sha256 sonoma:        "deeadddce373b6de5ccec4d6d099469053249f0996925ed10f86fbab7a98a9d0"
    sha256 ventura:       "a1990cc9a88ffefd484031a4ff1ef3f6f48b1463ff63faa46717bab788f24c52"
    sha256 arm64_linux:   "53b79c3286b2ce58e488279952484cf3259aaf29497df0cad5d04e136072319c"
    sha256 x86_64_linux:  "13254b818d239db801f45ffb4421fb6299bc5522f64403974e450e07633d065c"
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
