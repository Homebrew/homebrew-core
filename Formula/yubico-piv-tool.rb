class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.1.1.tar.gz"
  sha256 "733aee13c22bb86a2d31f59c2f4c1f446f0bca2791f866de46bf71ddd7ebc1b3"
  license "BSD-2-Clause"

  bottle do
    sha256 "11cdcfe2fe335c75e79d00b3b47e0e7970f491b5b6021dc1e53b99cb799359e9" => :catalina
    sha256 "aec7c7f3cca7e869700ebc5b9a175b0ee48c76079e1f6d29c81431b4b2f9c17e" => :mojave
    sha256 "87938ef20245216c4b5abef4142fc160e6ef52551406c39c01e533b6be07ca1d" => :high_sierra
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
