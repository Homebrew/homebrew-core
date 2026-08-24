class Vcflib < Formula
  desc "C++ library and cmdline tools for parsing and manipulating VCF files"
  homepage "https://github.com/vcflib/vcflib"
  url "https://github.com/vcflib/vcflib/releases/download/v1.0.15/vcflib-1.0.15-src.tar.gz"
  sha256 "178e8c27fffc5324ac73f1c4b35f407184271b57f82aedc2efb9703df6ee3d49"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "837e94d79bd6b94f62aa5da9ada2695c30421933fbbf121bff6d3bc32bfe8ac0"
    sha256 cellar: :any, arm64_sequoia: "ce48bd31457f57bbdc44ccca1bcc198a7002d7a91069fb352c980318d19241ef"
    sha256 cellar: :any, arm64_sonoma:  "0bbc25128abb0a232e460042373b9d8ac516c6f47dae1d5107d66c591b4b0de7"
    sha256 cellar: :any, sonoma:        "572645a1d26f3f0de4c7dd2a704fec02a70b53bc9f209c9147d9b0f3951ddd4f"
    sha256 cellar: :any, arm64_linux:   "9151d202f36c0f4ec53c44ae264a7f5a0466aff4a7c477c70d5ac32e03de2c02"
    sha256 cellar: :any, x86_64_linux:  "3262faae8a544bd217c646635d6309e2555612aeec51fdc6ebb77f07cacdde69"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "pybind11" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "htslib"
  depends_on "wfa2-lib"
  depends_on "xz"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = ["-DZIG=OFF"]
    args << "-DCMAKE_INSTALL_RPATH=#{rpath}" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcfcheck --version")

    assert_match "fileformat=VCF", shell_output("#{bin}/vcfrandom")

    ENV["PYTHONPATH"] = lib
    system "python3.14", "-c", "import pyvcflib"
  end
end
