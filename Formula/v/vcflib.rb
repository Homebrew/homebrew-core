class Vcflib < Formula
  desc "C++ library and cmdline tools for parsing and manipulating VCF files"
  homepage "https://github.com/vcflib/vcflib"
  url "https://github.com/vcflib/vcflib/releases/download/v1.0.15/vcflib-1.0.15-src.tar.gz"
  sha256 "178e8c27fffc5324ac73f1c4b35f407184271b57f82aedc2efb9703df6ee3d49"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dae474cbc0c7e6df472e8a8b7d903fcc326706e985391a533a92eecdcab56dc5"
    sha256 cellar: :any,                 arm64_sequoia: "ef9292a2426c8dde700d72dbef0a8c90b64aca16e13408dcebff8153381563f7"
    sha256 cellar: :any,                 arm64_sonoma:  "f20a7074ff10f55f5f61b7c1c7664c695716ab9e423580b0ec58c9b909c88408"
    sha256 cellar: :any,                 sonoma:        "3e65b889529b3887e5ee65f67aca8cf7321bd151635af66767f0a1eb2a9ff009"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "593cc2e3478b480c04250f7396747e8d4a3e3dff01ac220a592b6cf3d4aaa03b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b270eec4b3a5cecdcef38f0f2fd32bf813d46753eeacbbb5471688b3855645e4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "pybind11" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "htslib"
  depends_on "wfa2-lib"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
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
