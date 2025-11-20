class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.7.2.tar.gz"
  sha256 "b84ade3c35d4949db008e6cda7b6cc70ff98858598b3f09bc46fd24a3d5f7461"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc4d38540be3670e46f3869649b5e146ce4f4349eb89f4e9970e4e06535b7667"
    sha256 cellar: :any,                 arm64_sequoia: "32cb4be3a8571a7383f46bd6886512be9cf152607629687a618fe6afa5ddc7e8"
    sha256 cellar: :any,                 arm64_sonoma:  "3f98f5e7d8cce1c8c28e6864baafc1d954db729e2a3532cb24d81f5078962ff8"
    sha256 cellar: :any,                 arm64_ventura: "107365d2ab19a689ee6e1fcca4e668e421cbdf34827cc60ae8cfc40a4b169914"
    sha256 cellar: :any,                 sonoma:        "6ac3d8eaacd71de131b103772a686dc99faf1b788f520b0ae8a55b3c670ded29"
    sha256 cellar: :any,                 ventura:       "ae1d85e46113176a51fb3d45659083282a276d993eea0de0bf22097152c28e2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0a9a36684962a27b66fca9a0785f9559351caee558610c516134518556bc00b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1faebfd4902a9927f7ffac93ee3396a4ca9fcb257585c87ccea3ad40b2197b4"
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
