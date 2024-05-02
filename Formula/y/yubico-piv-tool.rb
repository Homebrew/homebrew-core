class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.5.1.tar.gz"
  sha256 "4262df01eec5c5ef942be9694db5bceac79f457e94879298a4934f6b5e44ff5f"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0741ff97b1982dc767cb2671d2172d92b4c2746a6e7bcdec0504c322aa40a540"
    sha256 cellar: :any,                 arm64_ventura:  "a1c5640d17accf813eee3ea7d02e7a2ee067b51c5fa6e26e875a8e7171bcb27e"
    sha256 cellar: :any,                 arm64_monterey: "fdb1e0f1623b924cda3e22e577df0bface7afe90d86e2dc1fb8e9def828b9386"
    sha256 cellar: :any,                 sonoma:         "faeec9fc77e45757bfb1b2be0ab2fad47b2d898ffde53849489e78b40efebaa2"
    sha256 cellar: :any,                 ventura:        "9d608c70e20b1c2c9bd1483bde5c6446eaf55d2f4a5ec1a860924a6c934c822c"
    sha256 cellar: :any,                 monterey:       "da71b189639d6fb532a551c830554ab7db496da1c5b47fa98a6b9e47ad2677eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16f33bbd4c6072f813a5d12881cba7bf698e10f63b2f6b76ec0e8d07d35847b7"
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "openssl@3"
  uses_from_macos "pcsc-lite"

  def install
    mkdir "build" do
      args = []
      args << "-DCMAKE_C_FLAGS=-I#{Formula["pcsc-lite"].opt_include}/PCSC" unless OS.mac?
      system "cmake", "..", *std_cmake_args, *args
      system "make", "install"
    end
  end

  test do
    assert_match "yubico-piv-tool #{version}", shell_output("#{bin}/yubico-piv-tool --version")
  end
end
