class Vc4asm < Formula
  desc "Macro assembler for Broadcom VideoCore IV aka Raspberry Pi GPU"
  homepage "https://maazl.de/project/vc4asm/doc/index.html"
  url "https://github.com/maazl/vc4asm/archive/refs/tags/V0.3.tar.gz"
  sha256 "f712fb27eb1b7d46b75db298fd50bb62905ccbdd7c0c7d27728596c496f031c2"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "212c820e20fe7369665a9193ac74df93754800cd6b538a8a1b76957310a844ac"
    sha256 cellar: :any,                 arm64_sequoia:  "c66f2ce86c71a5c824c8e0f19edd39b714ae56d6f3ebdfc287fa7549e66a8f2d"
    sha256 cellar: :any,                 arm64_sonoma:   "8292e0e5586e00d1e0c74c5b411ac925547a0b46dbdbd3ca54b7ffc95eed2248"
    sha256 cellar: :any,                 arm64_ventura:  "49337c5ba68c5868f9804568af0ab0fc29223eee04b6f50154fa30ef49fb23f1"
    sha256 cellar: :any,                 arm64_monterey: "af417dc649bc49003da98b9756e05da700076907cc4963818b839b817f721bc5"
    sha256 cellar: :any,                 arm64_big_sur:  "64082d8d1fd7f2a360f9ffdd29a9fbde0a24b600f38806bc4556e4ea9b5175bc"
    sha256 cellar: :any,                 sonoma:         "87bd89c5992b3b7fdbd6d87bcc9fe0a96958dddbb4cad8ee1210d19d84b32c49"
    sha256 cellar: :any,                 ventura:        "3962b9835cebd3238c331effab584026a12adfec4be373c174e7f7575a9e8ff7"
    sha256 cellar: :any,                 monterey:       "1a80a7ddd01b91da357ecae8507af244f0dde770275e36ee523b0da7c0f489f4"
    sha256 cellar: :any,                 big_sur:        "1eefbd03ec375b8021eb783af2fdf5e343c5548201eddbb29e6cf9b6db47e80c"
    sha256 cellar: :any,                 catalina:       "cd4f683e1e968cb0577b7e6d9b054c503719b10f9bd37442feb8481a19d75fd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f6fa60166e7cf2540a0a7f87c2b179b3b0bb2df5e9c9a764cf883c5b03baab18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c0fe82118a412102288a10b2470baa741000c5448d6a1fa719fd8974daf73eb"
  end

  depends_on "cmake" => :build

  # Backport fix for GCC 9+
  patch do
    url "https://github.com/maazl/vc4asm/commit/ff16f635b07e14b07c1de69bf322e3bf7feecd93.patch?full_index=1"
    sha256 "b4c6e87018aa512ff8398cc77bd3f80dd9aaca196c3da76a845db7e25eaac99b"
  end

  def install
    # Upstream create a "CMakeCache.txt" directory in their tarball
    # because they don't want CMake to write a cache file, but brew
    # expects this to be a file that can be copied to HOMEBREW_LOGS
    rm_r "CMakeCache.txt"

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.qasm").write <<~ASM
      mov -, sacq(9)
      add r0, r4, ra1.unpack8b
      add.unpack8ai r0, r4, ra1
      add r0, r4.8a, ra1
    ASM
    system bin/"vc4asm", "-o test.hex", "-V", "#{share}/vc4inc/vc4.qinc", "test.qasm"
  end
end
