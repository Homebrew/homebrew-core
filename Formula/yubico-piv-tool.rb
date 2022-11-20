class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.3.0.tar.gz"
  sha256 "a02a12d9545d1ef7a1b998606d89b7b655a5f5a1437736cf51db083f876f55a9"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "003a83e34fadee641720bf199666c4ac9379fd781c1962d48c55020bc19e5237"
    sha256 cellar: :any,                 arm64_monterey: "8f318d73ecaba695565af93bb8b17220832e30c51cae308b9b3737788e394975"
    sha256 cellar: :any,                 arm64_big_sur:  "99b5bb89e217f0e98b5edaf95b75a2d50c07a5f593a104edc66518d51e86e59b"
    sha256 cellar: :any,                 ventura:        "d8b283f9d158783072fa1c83cc11f26809143ef657c62dcd15541759ade0d6f1"
    sha256 cellar: :any,                 monterey:       "963208d74145e747d84890ad0515214e9fa843d103cebd74501e1230eda7a2b7"
    sha256 cellar: :any,                 big_sur:        "ba15d7a429b902fcc6cfdd6c5378081b01d22a28779a7571e268e1d5d10ff1d8"
    sha256 cellar: :any,                 catalina:       "118ab85bbda0694c6edc746dd210849814c05c41a586217c9ed974d67f406a30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fba7bda0c4156d76af37f971ead7c8a39d395fa62cacc8ab69d20f8bce77ea98"
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
