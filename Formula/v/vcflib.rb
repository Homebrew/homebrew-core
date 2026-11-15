class Vcflib < Formula
  desc "C++ library and cmdline tools for parsing and manipulating VCF files"
  homepage "https://github.com/vcflib/vcflib"
  url "https://github.com/vcflib/vcflib/releases/download/v1.0.15/vcflib-1.0.15-src.tar.gz"
  sha256 "178e8c27fffc5324ac73f1c4b35f407184271b57f82aedc2efb9703df6ee3d49"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "0b339d97915ac67f305370bd1740bbdd9a75250960b4e71ad5a7c5d24d7654cd"
    sha256 cellar: :any, arm64_tahoe:       "680d0feafdaec559754c45d28da285e78f0e856c524e9f20ae06c1dc68808e77"
    sha256 cellar: :any, arm64_sequoia:     "d13ba9f4eb4c624162094da61897ac7952920a1db1dc178456462e40b24977df"
    sha256 cellar: :any, arm64_linux:       "153b819d6f30821671f8804510f20f968a94bc3525795adba509863f4e0885c0"
    sha256 cellar: :any, x86_64_linux:      "faa9ad16ac410cb8f59f2e55b0dc694c3ef734eaa3a5a48b66ea7737027a683c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "pybind11" => :build
  depends_on "python@3.15" => [:build, :test]
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

  deny_network_access!

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
    system python3, "-c", "import pyvcflib"
  end
end
