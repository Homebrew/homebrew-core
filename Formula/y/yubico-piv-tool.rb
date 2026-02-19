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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e333d0e9ab4d352ec6e6ceab61be769ef2c75bf2c3d71727b902ff636ae62a45"
    sha256 cellar: :any,                 arm64_sequoia: "0a2c7096892f5466c58e8c882c38c89a972aa6679ad0ab54a483669eb5d29732"
    sha256 cellar: :any,                 arm64_sonoma:  "9e5fa0af709675cfd39ed0e696e1eea9bc31ac039999a377b86e0b9bf555946e"
    sha256 cellar: :any,                 sonoma:        "a54fe53dd00eac5705e8bca16907ad020e7616fdc5a180a3f4a9dc1f2755afd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d26838f59ec2946210ed9a5116fa68ff5dbc32ad909cf9e8faf401392f9beb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f7c8857568353e8e6429257d68babd45390b03dc9db2b6636a36c2ddec458af"
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "pcsc-lite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["pcsc-lite"].opt_include}/PCSC" unless OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "yubico-piv-tool #{version}", shell_output("#{bin}/yubico-piv-tool --version")
  end
end
