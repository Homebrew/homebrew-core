class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.5.2.tar.gz"
  sha256 "918e76bad99463dc0a858a4771ec674a579fad284d99d90c57fb9cf44fb059b8"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8820544ef87de8223558a920d256f599f96ce34345539aaf92bd306047c786ab"
    sha256 cellar: :any,                 arm64_ventura:  "2edf06269841a82731ebaf0c12e21a8104de4ccc2ca5343d4cd4f1b9e7398fc9"
    sha256 cellar: :any,                 arm64_monterey: "3734da6bb92f5e07eae7aa4c993074bdb707ffe52cbc5c9996408b1344656dbb"
    sha256 cellar: :any,                 sonoma:         "68fb25543cdbc53ca1570751caba3219adab1d5fe6a3e89e8f914c6c5ae35d06"
    sha256 cellar: :any,                 ventura:        "a200ed2f9995a807509d59896dc8fa937ca1964ff0a6921951643faee3e4c514"
    sha256 cellar: :any,                 monterey:       "2d54e9bf8093ab0237086c81368832f7dedb3581c0937fe9bc31b8f7f6c8acbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "837442ffcf1748789709744e97492bdc5e84d9743cae3596a75f23622d6ed4c6"
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
