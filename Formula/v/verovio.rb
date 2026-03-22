class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-6.1.1.tar.gz"
  sha256 "4ac970d31d984f397d40cd8ed35ff1731b694594d93e323f98584135df256560"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_tahoe:   "d8fb955b157de20cfb4504372294a105569aaafdffe411d94abc4fd7e932304c"
    sha256 arm64_sequoia: "d035d1d373717865bd2d6af9904bc973b2bc6ba83b3dd1aa33d00dcd9df61ee8"
    sha256 arm64_sonoma:  "91819ad244d3fbe1f4387cee1d4cc1b610dd0df0becb136ef697ac1a278c34e3"
    sha256 sonoma:        "517f2d070ec72ff73244288fa159fb4567bf21d6172d40698663c5472b26cc0d"
    sha256 arm64_linux:   "39b3eb83c8cfe8e4bc2435b6512a3ec5446c1a0ebccfaa1a883edff7f4563799"
    sha256 x86_64_linux:  "1aa461cefc12b12a223c979d5a568ca0c57d0ef00df888fdfb6c95e266e76d9f"
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
