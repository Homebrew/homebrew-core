class Vc4asm < Formula
  desc "Macro assembler for Broadcom VideoCore IV aka Raspberry Pi GPU"
  homepage "http://maazl.de/project/vc4asm/doc/index.html"
  url "https://github.com/maazl/vc4asm/archive/V0.3.tar.gz"
  sha256 "f712fb27eb1b7d46b75db298fd50bb62905ccbdd7c0c7d27728596c496f031c2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "86cda7631f6e50ef12f26198ec3810684b9d74599b12b1e68af2ae77857119ae"
    sha256 cellar: :any_skip_relocation, big_sur:       "f7899b26e3ad1fc2dd969b8178f24ddad5049164e30d6039443c9eac691b29a6"
    sha256 cellar: :any_skip_relocation, catalina:      "d8a425ef7d84c5a1ba477c07e3b04f5fddb0dce92e5cf67a963ecfbc12b3caec"
    sha256 cellar: :any_skip_relocation, mojave:        "fc0a060875dd9233a3675b034055b1ae23d8775701529024b91f184a7e97521e"
    sha256 cellar: :any_skip_relocation, high_sierra:   "db9bbf5ee3cb47a0f3ffa1d9bf355205873237e9f2dbd26777546935401ef4b0"
    sha256 cellar: :any_skip_relocation, sierra:        "2547c982e3fde40316d01d802bd01bf49af208e6737ecafeaeb8ad988ea3255d"
    sha256 cellar: :any_skip_relocation, el_capitan:    "72d54a4237c4e0f952fd1a3d913725d84814ed5b657affa1d6dcafa19e1cdc44"
    sha256 cellar: :any_skip_relocation, yosemite:      "871b3b109ac49b09056f83e4488105196060d2388dc5052c679776b43fab5927"
  end

  depends_on "cmake" => :build

  def install
    # Upstream create a "CMakeCache.txt" directory in their tarball
    # because they don't want CMake to write a cache file, but brew
    # expects this to be a file that can be copied to HOMEBREW_LOGS
    rm_r "CMakeCache.txt"

    system "cmake", "-S.", "-Bbuild", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.qasm").write <<~EOS
      mov -, sacq(9)
      add r0, r4, ra1.unpack8b
      add.unpack8ai r0, r4, ra1
      add r0, r4.8a, ra1
    EOS
    system "#{bin}/vc4asm", "-o test.hex", "-V", "#{share}/vc4inc/vc4.qinc", "test.qasm"
  end
end
