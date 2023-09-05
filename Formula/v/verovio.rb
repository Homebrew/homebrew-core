class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-4.0.1.tar.gz"
  sha256 "8d775ae451f53ba216c9f816923fa75d7c32dd47edb124124cd2964b5595d054"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_ventura:  "302a7600f979fdb9a7cf7203b2677f5a49c3531af33b381ee8e947c42d7089da"
    sha256 arm64_monterey: "edf83dbd631a23a8ced3cb90298e6477e534924e30e61d1a3bfae3e752570a74"
    sha256 arm64_big_sur:  "060af4153fe1fe282319d5cca5a664d58a1ace4c63e66721be3cfd5b3faefae6"
    sha256 ventura:        "00250c80f7170bad00b019be46437120e08b6e97e8312379c12f9f3f34f8349b"
    sha256 monterey:       "a445824ac01fe8c38676dc8dea3480ec6d0927048252eff3a70809588db9e642"
    sha256 big_sur:        "d46de2759e6fb3184405484f9560948ff2b98b174c9be687913155ba38d09d9e"
    sha256 x86_64_linux:   "f1abcada9a518045225c39934ec54ba3c2bd1855b905b6c98ca211d6af092686"
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
