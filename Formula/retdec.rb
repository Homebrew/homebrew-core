class Retdec < Formula
  desc "Retargetable machine-code decompiler based on LLVM"
  homepage "https://github.com/avast/retdec"
  url "https://github.com/avast/retdec.git",
    tag:      "v5.0",
    revision: "53e55b4b26e9b843787f0e06d867441e32b1604e"
  license all_of: ["MIT", "Zlib"]
  head "https://github.com/avast/retdec.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "b7cde2657b59f79866cd54252feccc890acf33a2b4d878c10e28fb370cf54e79"
    sha256 cellar: :any,                 arm64_monterey: "7113e40714bd347a886920c65a00f9267de5ade96fe76d8ae6a16aca074aa0d4"
    sha256 cellar: :any,                 arm64_big_sur:  "c5f2c1b8668e3b931b3fa4806e6072a1c397427d16c8bd3fe04addb713860873"
    sha256 cellar: :any,                 ventura:        "c3d083e2d657f03bc597359bd3a70a4567c1e0cdc1ed1a9c483821cea07a8802"
    sha256 cellar: :any,                 monterey:       "a2ce1d3714eb89c08ed0c2b4f1ed0618646a03e50e79d6adb8074ed05184e3b1"
    sha256 cellar: :any,                 big_sur:        "71305564bb1b74ab1b83345bec0eefd44151bfe46c35b42d352bd55017bcff3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcf8464ae585bc75c3a5b0cbf5520a933905775f67046a76c51290c70d4e13bc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  on_macos do
    depends_on xcode: :build
    depends_on macos: :catalina
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Running phase: cleanup",
    shell_output("#{bin}/retdec-decompiler -o #{testpath}/a.c #{test_fixtures("mach/a.out")} 2>/dev/null")
  end
end
