class Retdec < Formula
  desc "Retargetable machine-code decompiler based on LLVM"
  homepage "https://github.com/avast/retdec"
  url "https://github.com/avast/retdec/archive/refs/tags/v4.0.tar.gz"
  sha256 "b26c2f71556dc4919714899eccdf82d2fefa5e0b3bc0125af664ec60ddc87023"
  license all_of: ["MIT", "Zlib"]
  head "https://github.com/avast/retdec.git", branch: "master"

  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on xcode: :build
  depends_on macos: :mojave
  depends_on "python@3.10"

  def install
    openssl = Formula["openssl@1.1"]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DOPENSSL_ROOT_DIR=#{openssl.opt_prefix}"
      system "make", "install"
    end
  end

  test do
    assert_match "##### Done!", shell_output("#{bin}/retdec-decompiler.py #{test_fixtures("mach/a.out")}")
  end
end
