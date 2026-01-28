class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-6.0.0.tar.gz"
  sha256 "6213e5397aee7a780d834cf8a0ffbb5b2a5c8992f2b3f0fa5f2748d935d39180"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_tahoe:   "3c86134a5057291b7e49d040e5659fc8d148c309c2f8bd6086e733187fed22b1"
    sha256 arm64_sequoia: "391bc9f30605ff4707ba5431cebb4536be60c5e9256cb012b79ef15d00432740"
    sha256 arm64_sonoma:  "b1fc8f3029a936e52a9057fb5613ecadca4213645b82374ccb01c8fb4a8b098e"
    sha256 sonoma:        "82f1ecc037e8ea0ba946a1d5f50c5b80eceaa5793d538733179c2bf49a69e4df"
    sha256 arm64_linux:   "dd494aeb821cda5b07ba56b92e8e240f562b35597928a2adc92bc283b4b3f7e5"
    sha256 x86_64_linux:  "743e8b5b21e9c182dcd461367dd398449f3d38ab34720c6a286cba193bd7e110"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "./cmake", "-B", "tools", *std_cmake_args
    system "cmake", "--build", "tools"
    system "cmake", "--install", "tools"
  end

  test do
    resource "homebrew-testdata" do
      url "https://www.verovio.org/examples/downloads/Ahle_Jesu_meines_Herzens_Freud.mei"
      sha256 "79e6e062f7f0300e8f0f4364c4661835a0baffc3c1468504a555a5b3f9777cc9"
    end

    system bin/"verovio", "--version"
    resource("homebrew-testdata").stage do
      shell_output("#{bin}/verovio Ahle_Jesu_meines_Herzens_Freud.mei -o #{testpath}/output.svg")
    end
    assert_path_exists testpath/"output.svg"
  end
end
