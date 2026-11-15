class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.7.3.tar.gz"
  sha256 "fcb25c42f54298ece8b20684fb3c581ed9195a162cbc55180a4161501be93181"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "e1483709af170adefa9460acf1b5df1588a58c200a78a1107c244de609326c2d"
    sha256 cellar: :any, arm64_tahoe:       "5276dc02eb4082e94f23377ce12607dcb3da58cfddeb39781eda5355a5b7e773"
    sha256 cellar: :any, arm64_sequoia:     "100e3a16c8c0029a0c896f1b0cc60725e2ddae683f1633c7a976ed7f594f3aa6"
    sha256 cellar: :any, arm64_linux:       "de22960e155a0d9fe5b64feeef907aef7b5296aaf80fcf88b5af15331777a5e3"
    sha256 cellar: :any, x86_64_linux:      "83d18863b29d2c476ab51746a5187be48e1860ecbde157dfaf7aec6bfd8a0656"
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  uses_from_macos "pcsc-lite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    ENV.append_to_cflags "-I#{formula_opt_include("pcsc-lite")}/PCSC" unless OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "yubico-piv-tool #{version}", shell_output("#{bin}/yubico-piv-tool --version")
  end
end
