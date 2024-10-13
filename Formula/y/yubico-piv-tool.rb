class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.6.1.tar.gz"
  sha256 "d4efd2d7c5baca49ffc070dea5fb64c17239095e0e54b10766a8a156b0c09285"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "4c2b827134614f52f63ff975ff69078b9014ab698bc9fe17721e23ef87b3dac2"
    sha256 cellar: :any,                 arm64_sonoma:   "be4e2c666d45c23553d4964357eaa8921417c64b48f2d04355ae46705e9761c7"
    sha256 cellar: :any,                 arm64_ventura:  "442df6b223e692469b77a1ebc0576fbb55e944252d51e33bd983447f3cd132bd"
    sha256 cellar: :any,                 arm64_monterey: "8ddc49bc10a2a6884f43e80e876e0c6962ee4d604a14e5a2da20b5cb226598d3"
    sha256 cellar: :any,                 sonoma:         "a2c42549ad862e2a0e5cda13052bdc9a930cd8d1b8e1a144f1be07885f6e1bf6"
    sha256 cellar: :any,                 ventura:        "db2740488dd6321dd460a395a11df1ee9b93ce916491ac393d8016a5a528cf51"
    sha256 cellar: :any,                 monterey:       "8c6949b47d7b6b857ea14dcc88e3ff2d9c39100d970e738e7d76abd71b0e20ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc638e52958800d21c0b1b981870ae56efcb035d312baa223f1bd97fa6166e39"
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
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
