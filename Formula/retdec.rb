class Retdec < Formula
  desc "Retargetable machine-code decompiler based on LLVM"
  homepage "https://github.com/avast/retdec"
  license all_of: ["MIT", "Zlib"]
  head "https://github.com/avast/retdec.git", branch: "master"

  stable do
    url "https://github.com/avast/retdec.git",
      branch:   "master",
      revision: "0749a46b2490c8d499d64f08629271e16c311d82"
    version "5.0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  on_macos do
    depends_on xcode: :build
    depends_on macos: :mojave
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    gcc = Formula["gcc"] if OS.linux?

    cmake_args = std_cmake_args
    cmake_args << "-DCMAKE_C_COMPILER=#{gcc.opt_bin}/gcc-#{gcc.version.major}" if OS.linux?
    cmake_args << "-DCMAKE_CXX_COMPILER=#{gcc.opt_bin}/g++-#{gcc.version.major}" if OS.linux?

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Running phase: cleanup",
    shell_output("#{bin}/retdec-decompiler -o #{testpath}/a.c #{test_fixtures("mach/a.out")} 2>/dev/null")
  end
end
