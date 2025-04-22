class Retdec < Formula
  desc "Retargetable machine-code decompiler based on LLVM"
  homepage "https://github.com/avast/retdec"
  url "https://github.com/avast/retdec.git",
      tag:      "v5.0",
      revision: "53e55b4b26e9b843787f0e06d867441e32b1604e"
  license all_of: ["MIT", "Zlib"]
  revision 1
  head "https://github.com/avast/retdec.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "216414b394e83210cce369da37d371ac44b4e3b6f6008fa16191efacc4ea9eaa"
    sha256 cellar: :any,                 arm64_sonoma:  "8b9441e8c153d05e91cbeef5688f58584b709eec12b38a9c5f0fcf7dd80b258f"
    sha256 cellar: :any,                 arm64_ventura: "666d104c2c81ebf92f83b239aa716bf7e798362558b3855f83de08df4120b260"
    sha256 cellar: :any,                 sonoma:        "12f78f71818e8477a1966f273a737e879246f72856e6a3d5cb3ddf134bbfe0fe"
    sha256 cellar: :any,                 ventura:       "a6b2b8f1befd6b68df9dd0dc1786ac4204c4106c9fe2d8d2d2bf2973ed6bb6e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d18898575fd9cfdcdbef7fae747b2dccd25ef42383c30a52f7616e95552d282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e46385c01a262b114048e4af0eea56b6ea7cffab2a39569faa28fd6e76f4fe4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on macos: :catalina
  depends_on "openssl@3"
  depends_on "python@3.13"

  uses_from_macos "zlib"

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
