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
    sha256 cellar: :any,                 arm64_tahoe:   "320d6fb4907b54dc41b690af1152a8b05fd01024134940ccd8a54a829fa5f746"
    sha256 cellar: :any,                 arm64_sequoia: "1a8f65fdf05b9477abb6a66d662dea1e6c0f0046f354079ac7d68c87e725f414"
    sha256 cellar: :any,                 arm64_sonoma:  "98f337f1a5402bae6ea817f6a86a644995e9d28b6af3f9b0c20d9276756afdd5"
    sha256 cellar: :any,                 sonoma:        "a41260d16d389ec3284a60778a0a8c6f2ccdc5ef437c6517fe0584935c90a5e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc5e5c432867677d106e846ea33d5e8afce20cf1e5efd62961eb715db8d78c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e24edf66b9e7d49f0da8a7e390a9b5a9ba018017671ec97c347cc26e1bfbdd8"
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "pcsc-lite"
  uses_from_macos "zlib"

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
