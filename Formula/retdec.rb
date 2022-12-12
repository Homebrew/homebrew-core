class Retdec < Formula
  desc "Retargetable machine-code decompiler based on LLVM"
  homepage "https://github.com/avast/retdec"
  url "https://github.com/avast/retdec.git",
    tag:      "v5.0",
    revision: "53e55b4b26e9b843787f0e06d867441e32b1604e"
  license all_of: ["MIT", "Zlib"]
  head "https://github.com/avast/retdec.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  on_macos do
    depends_on xcode: :build
    depends_on macos: :mojave
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
