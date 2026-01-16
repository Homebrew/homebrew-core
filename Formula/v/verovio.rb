class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-5.7.0.tar.gz"
  sha256 "bf7483504ddbf2d7ff59ae53b547e6347f89f82583559bf264d97b3624279d5e"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_tahoe:   "44a8348b30e9f5754028c3705bd47250fda643832814fd580f9cb853e6930035"
    sha256 arm64_sequoia: "0fda1bf7c351d109efa9d13bbdec01ecf5b607db9528c3de1d1bbdfd94fbde70"
    sha256 arm64_sonoma:  "0d7cc593baf109e964840d0be52482230da81d0b868573641a780aee09803070"
    sha256 sonoma:        "366130d51b4e6b381e8e17cd0e603575c1bf14273d0927f92da7174a71251287"
    sha256 arm64_linux:   "bbf856574f2648bf2fb8de52ce1ac193ae966e0590124ea337b82ea604f61dc4"
    sha256 x86_64_linux:  "1aae8cc347a6b109191809767f8f96d094dde98f3d48da8dbecd5d9ff3147ed4"
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
