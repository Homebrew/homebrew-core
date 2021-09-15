class Vc4asm < Formula
  desc "Macro assembler for Broadcom VideoCore IV aka Raspberry Pi GPU"
  homepage "http://maazl.de/project/vc4asm/doc/index.html"
  url "https://github.com/maazl/vc4asm/archive/V0.3.tar.gz"
  sha256 "f712fb27eb1b7d46b75db298fd50bb62905ccbdd7c0c7d27728596c496f031c2"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "64082d8d1fd7f2a360f9ffdd29a9fbde0a24b600f38806bc4556e4ea9b5175bc"
    sha256 cellar: :any,                 big_sur:       "1eefbd03ec375b8021eb783af2fdf5e343c5548201eddbb29e6cf9b6db47e80c"
    sha256 cellar: :any,                 catalina:      "cd4f683e1e968cb0577b7e6d9b054c503719b10f9bd37442feb8481a19d75fd7"
    sha256 cellar: :any,                 mojave:        "5d806a353310bda8308cc207ff165541253d7a7ea39189ce156d066e5d7b4514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c0fe82118a412102288a10b2470baa741000c5448d6a1fa719fd8974daf73eb"
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
