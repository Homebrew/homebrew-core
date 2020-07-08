class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.1.0.tar.gz"
  sha256 "ae6a51cc20c5aa92c3ff2d18411edc49512564cb824ce28e533755cea16287f5"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "f85cee9151108f2ca5e6e067d846123c1d55044d26ec8c7c3a29a3b7ba4e81f8" => :catalina
    sha256 "b4d327cc5524b7cbbbb4bf241b59f5d19556484bd5c3109964d070a7586578a2" => :mojave
    sha256 "1e5c8cc9a64bdfbae6d16b27029e24d9290d2f449f7ef6e90b7c47ea29cf2b3f" => :high_sierra
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
