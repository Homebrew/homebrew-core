class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-6.3.0.tar.gz"
  sha256 "095a561e9bd26c97787ad49e01009576d1ca234feae3995948c5aede97a40598"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_tahoe:   "7b0fcc16a628733ded5cfa3490a2d96bbc825a0bcef8f4f076124aa7969523bf"
    sha256 arm64_sequoia: "e0c72ab7fb754fc15d3f34da4cb3fc6c4a39fda49c0da7ae52cd0ebe86b3505c"
    sha256 arm64_sonoma:  "df460eb6c53ca11c495e2ffeefa75ba68e403a808f78e2da599e36a2ccc6503d"
    sha256 sonoma:        "c0186855ef32b3b2936656dd3ed054e5e6d50a7a9c74df8b3508798a20e2f9f1"
    sha256 arm64_linux:   "b9dbfe6ec9034fc921dfca5c9eb69b0c8a29691348815471a2411f3ecf5db7c5"
    sha256 x86_64_linux:  "5625c30f36956341891b263aeeb4d1781d100b7cf1755b938621b8caddceff50"
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
