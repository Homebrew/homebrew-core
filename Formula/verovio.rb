class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-3.15.0.tar.gz"
  sha256 "136a74e21fce9657a573edf1340f8320b8ff867cd6e0e498c5715742208fadda"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256                               arm64_ventura:  "b50f6e3c56e4721fb446857700316a7ed3c7995282cfc45b219228e421e199c7"
    sha256                               arm64_monterey: "61acaaaa88110455415e3db48ff18a7e6f725b988b1ea8ee9f4d9c4f7fcef28e"
    sha256                               arm64_big_sur:  "61428069ed215e17966fe90522618178806f7f7cb3c295956345df911619b3bb"
    sha256                               ventura:        "de6de30174e049fa9d17777c8b6a8de5d49a58eb5caf1f0f478419fa5c41fc74"
    sha256                               monterey:       "7c9daadc59a1e20c7a49c442e08b2664e387a2ea8b1c44420fe03df17708f06a"
    sha256                               big_sur:        "0cdeceb6bb11607f6e69ec398c7eb4d932a568e70f4386247808c7cdf2c0c9e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc57a81a252167b38b5600b885ae4aae69c2214629dabf0ac5a43951e4231313"
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
