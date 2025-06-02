class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.7.1.tar.gz"
  sha256 "9813190a5c2560ef7fe8018c03614091e911e0596c5853ef25c82cd9283a444b"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "852e180ed2fe18fe28777716db26c09e754238744f889078b61d137d61fa6e80"
    sha256 cellar: :any,                 arm64_sonoma:  "c7a5dc4310d0f45106800d409de0933feda9ff5cedb14fae0b0c5d73df545ffe"
    sha256 cellar: :any,                 arm64_ventura: "5270a529dab82aaf84696ae71fedf63786d36c20209bcd701debada9e08e6e5b"
    sha256 cellar: :any,                 sonoma:        "8f3beb1c9c8532e03fe3730b561c2d54aa98def4f5d4c9e26ba3682acba762b5"
    sha256 cellar: :any,                 ventura:       "c31f355c89499b1e03ca9655c03e0c9e7f279d6ce236238de851ccae68d1c2bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42bcc272539ce1f7047b105bd7cee46499f8dd95753553fe2b9f2d7f06a79fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e54ae29bc9056bc7763ee41cf8db4b6dbb744d43f1c7903e6d8d480d9b0014fd"
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
