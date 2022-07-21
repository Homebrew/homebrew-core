class Retdec < Formula
  desc "Retargetable machine-code decompiler based on LLVM"
  homepage "https://github.com/avast/retdec"
  license all_of: ["MIT", "Zlib"]
  head "https://github.com/avast/retdec.git", branch: "master"

  stable do
    url "https://github.com/avast/retdec.git",
      branch:   "master",
      revision: "8503282c6d1295ba58ed5fed4ccb5605ed3febfd"
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
    depends_on "gcc@7" => :build
  end

  def install
    gcc = Formula["gcc@7"] if OS.linux?

    cmake_args = std_cmake_args
    cmake_args << "-DCMAKE_C_COMPILER=#{gcc.opt_bin}/gcc-7" if OS.linux?
    cmake_args << "-DCMAKE_CXX_COMPILER=#{gcc.opt_bin}/g++-7" if OS.linux?

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
    end
  end

  test do
    test_cmd = %W[
      #{bin}/retdec-decompiler
      -o
      #{testpath}/a.c
      #{test_fixtures("mach/a.out")}
      2>/dev/null
    ]
    test_cmd = test_cmd.join(" ")

    assert_match "Running phase: cleanup", shell_output(test_cmd, 1)
  end
end
