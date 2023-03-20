class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-3.15.0.tar.gz"
  sha256 "136a74e21fce9657a573edf1340f8320b8ff867cd6e0e498c5715742208fadda"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_ventura:  "931868eda5027f8e0d3c5caaa169881759a1b3d4921d02009cc4bdd504122044"
    sha256 arm64_monterey: "c54f988c5454b72a46aba0dae9966d080d43ee954ee24bcecbe954d3fbd63a93"
    sha256 arm64_big_sur:  "bca95a1a831c287fba3e902d0e5efc3a284b5f0d4c66bf3864f4431ba310f2dc"
    sha256 ventura:        "f441b3b529427d10a0d6abde7136c824f7e9bbbc02fd722b8cb35c456734fc54"
    sha256 monterey:       "568cc8bdd65885639529fde4d0803b287a2a2d9251679ee88ada871f262c43e2"
    sha256 big_sur:        "8494d2d29f0f050d18339b98bccdc8d76cf6518e867cf4d6da04475fc3eb5dd1"
    sha256 x86_64_linux:   "3d559f2ebeda3c3ee3409f0d64c6b48c558b38f0c3ff0a4357bc7bd34e798302"
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
