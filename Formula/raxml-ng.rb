class RaxmlNg < Formula
  desc "RAxML Next Generation: faster, easier-to-use and more flexible"
  homepage "https://sco.h-its.org/exelixis/web/software/raxml/"
  url "https://github.com/amkozlov/raxml-ng.git",
      tag:      "1.2.0",
      revision: "fd32e7f73c3ee44c526c7555a8d04e84b03bd51c"
  license "AGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "6e3db16bc310a565d8af3c0ca2b9775bf760f9e07f89ef776ef198b6ab6404a5"
    sha256 cellar: :any,                 arm64_monterey: "2229ebeb6fa282a4e3f97896ef02ba2d32671d497bc65188dc118d13239693d8"
    sha256 cellar: :any,                 arm64_big_sur:  "0236a1f00a663905ad3f3a8eb0cff275900f7f0b29a4ff65616b82384bb01467"
    sha256 cellar: :any,                 ventura:        "d4b7f0b7df9d8c4179a237e9317561e7a6e3904d62a16231be25d6eff815440c"
    sha256 cellar: :any,                 monterey:       "ffce4563023dbcd2e0eea0f6c06a0f33157561f412557cab49ed4c412c32562e"
    sha256 cellar: :any,                 big_sur:        "c6cb8ca0d17b1d5a2c074e236c63d0fcd848db96d026393566e1c4fec4d82f9d"
    sha256 cellar: :any,                 catalina:       "e62985fdf3fc153cb53c87a4ab230b4e33b9b55a0c990cabd774c27a1ab7d6d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1b99fec129377549ae701ce7eae61eb0289fe34f9e33d11c452c5bf0b1b584d"
  end

  depends_on "cmake" => :build
  depends_on "gmp"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "open-mpi"
  end

  resource "homebrew-example" do
    url "https://sco.h-its.org/exelixis/resource/download/hands-on/dna.phy"
    sha256 "c2adc42823313831b97af76b3b1503b84573f10d9d0d563be5815cde0effe0c2"
  end

  def install
    args = std_cmake_args + ["-DUSE_GMP=ON"]
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Upstream doesn't support building MPI variant on macOS.
    # The build ignores USE_MPI=ON and forces ENABLE_MPI=OFF.
    # This causes necessary flags like -D_RAXML_MPI to not get set.
    return if OS.mac?

    system "cmake", "-S", ".", "-B", "build_mpi", *args, "-DUSE_MPI=ON"
    system "cmake", "--build", "build_mpi"
    system "cmake", "--install", "build_mpi"
  end

  test do
    testpath.install resource("homebrew-example")
    system bin/"raxml-ng", "--msa", "dna.phy", "--start", "--model", "GTR"
  end
end
