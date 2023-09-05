class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-3.16.0.tar.gz"
  sha256 "ede6b281e6cdecceed6d70406a547b0e68f0d488b954b2a0440a8a8471833d6a"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_ventura:  "d09c344422d5b22f15bdcc0e01b2e0742c4e03fccfee000a8b27f567c8a55973"
    sha256 arm64_monterey: "c94a9e3c7cfbec7cee70295696165cec755eab1188666b7e69d367c541d8d14f"
    sha256 arm64_big_sur:  "7f2a0bad87053b37404aca2f473997de8659649e0f154076ec144575cbe8eefc"
    sha256 ventura:        "081ad04c57c13386a0c56681105c8b73e1da560e17cf48b36f5b6bc1cb8610fe"
    sha256 monterey:       "354bbf839c364453f5f5d275e72957aca0c8de40748084baabcf894be7f68bc6"
    sha256 big_sur:        "5cf637b2b79fc9ea9ca550c23107b2f76755f1ddc3965940be08d2508738b6d7"
    sha256 x86_64_linux:   "1c497a61d9124e5581373a9057e12fd4c9eb4c5d957773e87f1fedfddcb4d961"
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
