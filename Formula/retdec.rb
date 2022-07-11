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
  depends_on "openssl@1.1" => :build
  depends_on xcode: :build
  depends_on macos: :mojave
  depends_on "python@3.10"

  def install
    inreplace "cmake/options.cmake", "set_if_at_least_one_set(RETDEC_ENABLE_OPENSLL
		RETDEC_ENABLE_CRYPTO)", ""
    inreplace "deps/CMakeLists.txt", "cond_add_subdirectory(openssl RETDEC_ENABLE_OPENSLL)", ""
    inreplace "src/crypto/CMakeLists.txt", "ALIAS crypto)", "ALIAS crypto)

    find_package(OpenSSL 1.1.1 REQUIRED)"
    inreplace "src/crypto/CMakeLists.txt", "retdec::deps::openssl-crypto", "OpenSSL::Crypto"
    inreplace "src/crypto/retdec-crypto-config.cmake", "openssl-crypto", ""

    openssl = Formula["openssl@1.1"]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DOPENSSL_ROOT_DIR=#{openssl.opt_prefix}"
      system "make", "install"
    end
  end

  test do
    assert_match "\#\#\#\#\# Decompiling!",
    shell_output("#{bin}/retdec-decompiler.py --no-memory-limit -o #{testpath}/a.out.c #{test_fixtures("mach/a.out")}")
  end
end
