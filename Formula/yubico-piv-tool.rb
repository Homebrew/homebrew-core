class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.1.1.tar.gz"
  sha256 "733aee13c22bb86a2d31f59c2f4c1f446f0bca2791f866de46bf71ddd7ebc1b3"
  license "BSD-2-Clause"

  bottle do
    sha256 "13da151129e6ae4bf5dbdc013890d5d8ce5b1328461716b454cc904cb21bb78b" => :catalina
    sha256 "ace3c2ecf7edae27f22f836edab9f1d6dd3527c2442284e9acb85eca88294a42" => :mojave
    sha256 "86e59608b3832aa49d4a7d36d14e0fd491ac00c0c9be81c3a17185d552212393" => :high_sierra
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "openssl@1.1"
  depends_on "pcsc-lite"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_C_FLAGS=-I#{Formula["pcsc-lite"].opt_include}/PCSC"
      system "make", "install"
    end
  end

  test do
    assert_match "yubico-piv-tool #{version}", shell_output("#{bin}/yubico-piv-tool --version")
  end
end
