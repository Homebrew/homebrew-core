class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-4.2.1.tar.gz"
  sha256 "6bad4fe4ac96ba455f423185d5ad67e8f323c996ef0418145f9239009c32ca52"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_sonoma:   "b37a50c3ad711fc13bace494f83d3799367de7a4a7979e879512910eaeb8cd50"
    sha256 arm64_ventura:  "12f88e6ac0ef0bb66f61a0df2e75e6f982945ad8cadc0fff19c2f3cba5a688cc"
    sha256 arm64_monterey: "defbf4fc6c33952a58638f1b749904c10d6b0577703fcc382e0eaa51d0417c6f"
    sha256 sonoma:         "af3e480f5b359a44bc881f54aafc907150584c7c37672fb8c9ed4cf9c9034367"
    sha256 ventura:        "317e60d9732342374e0e1721021cbc5fe3a2325bc0b4d9f40df1d62996e76fc8"
    sha256 monterey:       "d71361c4d16c5ae8a708fa6cb05d46aac3d396478cda32fdf3859a44be1e44b3"
    sha256 x86_64_linux:   "6e5019a1dcef48ae2cac54165014d7c6b10cf8d494760478c1f10f2b4e4b3224"
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
