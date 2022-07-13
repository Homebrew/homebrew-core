class Retdec < Formula
  desc "Retargetable machine-code decompiler based on LLVM"
  homepage "https://github.com/avast/retdec"
  url "https://github.com/avast/retdec/archive/refs/tags/v4.0.tar.gz"
  sha256 "b26c2f71556dc4919714899eccdf82d2fefa5e0b3bc0125af664ec60ddc87023"
  license all_of: ["MIT", "Zlib"]
  head "https://github.com/avast/retdec.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "python@3.10"

  on_macos do
    depends_on xcode: :build
    depends_on macos: :mojave
  end

  on_linux do
    depends_on "gcc@7" => :build
  end

  def install
    inreplace "cmake/deps.cmake", "1.1.1c", "1.1.1i"
    inreplace "cmake/deps.cmake",
      "97ace46e11dba4c4c2b7cb67140b6ec152cfaaf4",
      "90cebd1b216e0a160fcfd8e0eddca47dad47c183"
    inreplace "cmake/deps.cmake",
      "f093df5cfd7521d8f6a09f250d7e69159d1001c47419130e806488de8a6312d8",
      "b12110d8a344f03b4f182fb111e6caa46a851e4966dc5975c4801af74a85cd7c"
    inreplace "deps/openssl/CMakeLists.txt",
      "set(OPENSSL_CONFIGURE_ARCH \"darwin64-x86_64-cc\")",
      "set(OPENSSL_CONFIGURE_ARCH \"darwin64-x86_64-cc\")
        elseif(ARCH_ARM64)
                set(OPENSSL_CONFIGURE_ARCH \"darwin64-arm64-cc\")"

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
      #{Formula["python@3.10"].opt_bin}/python3
      #{bin}/retdec-decompiler.py
      --no-memory-limit
      -o
      #{testpath}/a.c
      #{test_fixtures("mach/a.out")}
      2>/dev/null
    ]
    test_cmd = test_cmd.join(" ")

    assert_match "\#\#\#\#\# Decompiling", shell_output(test_cmd)
  end
end
