class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-3.13.0.tar.gz"
  sha256 "e9aaffe794fcdff6e7ff19a7a31f086d204f67e83fa395ccc8f58535840736ec"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_ventura:  "0a786651a5bd9f2b73b2a497378da74c97429afffa644968e903b3088def61e3"
    sha256 arm64_monterey: "c461373faa7feb7a31baf74b1b37f15ad33a01ff24275b884f62e22fdf3f5283"
    sha256 arm64_big_sur:  "9a0d7188892d14e3b60716d05935b03401d3cea7ec06e8e0d7ae946bedf5c11a"
    sha256 monterey:       "66114a5166a09429f6e6cc471587de2c52c21f79a130f2f8b2f2ad1b7715f7b6"
    sha256 big_sur:        "0f6fefdbe9555c4a74c7b34d9327c54af9c7213f479eab6997c32d54b3529fec"
    sha256 catalina:       "e82ec17f322b84e355be05fb126e3cc7b9e111f7f600717fa2c336e16ddab111"
    sha256 x86_64_linux:   "0dc609a4c40ad990b1cd053340b74366f16249b1bc32b026baa0d55f4b23f6de"
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
