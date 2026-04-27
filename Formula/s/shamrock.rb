class Shamrock < Formula
  desc "Astrophysical hydrodynamics using SYCL"
  homepage "https://github.com/Shamrock-code/Shamrock"
  url "https://github.com/Shamrock-code/Shamrock/releases/download/v2025.10.0/shamrock-2025.10.0.tar"
  sha256 "72683352d862d7b3d39568151a17ea78633bd4976a40eacb77098d3ef0ca3c55"
  license "CECILL-2.1"
  revision 1
  head "https://github.com/Shamrock-code/Shamrock.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "3a4b6abe7311675747688a24a4b69fe4794439064ff1372ddb18ed1b6685e0d3"
    sha256 arm64_sequoia: "c8e5075287712f42b20206af5e925a59a10a5c003a82b3a40a26fe5b31f48cd3"
    sha256 arm64_sonoma:  "ad89ac895bc5a48070c2e4b549aab4e065a47da7c769b1515aa506c34ea1ac37"
    sha256 sonoma:        "aa9ef69b838248a8a97c0324a185e5dfc90dd0499e7a6a6a788021c47ee1b5ec"
    sha256 arm64_linux:   "6e84aedba59883745395064325e3b323878fcae2adbd82dc72f6afbd6186a9fa"
    sha256 x86_64_linux:  "b1859d212b43118e69cd090125643b38dace8695b78edca1666d35e94191e704"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pybind11" => :build
  depends_on "adaptivecpp"
  depends_on "boost"
  depends_on "open-mpi"
  depends_on "python@3.14"

  on_macos do
    depends_on "libomp"
  end

  def python
    which("python3.14")
  end

  def site_packages(python)
    prefix/Language::Python.site_packages(python)
  end

  def install
    rm_r(%w[
      external/fmt
      external/nlohmann_json
      external/pybind11
    ])

    args = %W[
      -DSHAMROCK_ENABLE_BACKEND=SYCL
      -DPYTHON_EXECUTABLE=#{python}
      -DCMAKE_INSTALL_PYTHONDIR=#{site_packages(python)}
      -DSYCL_IMPLEMENTATION=ACPPDirect
      -DCMAKE_CXX_COMPILER=acpp
      -DACPP_PATH=#{Formula["adaptivecpp"].opt_prefix}
      -DSHAMROCK_EXTERNAL_FMTLIB=ON
      -DSHAMROCK_EXTERNAL_JSON=ON
      -DSHAMROCK_EXTERNAL_PYBIND11=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"shamrock", "--help"
    system bin/"shamrock", "--smi"
    system "mpirun", "-n", "1", bin/"shamrock", "--smi"
    system python, "-c", "import shamrock"
  end
end
