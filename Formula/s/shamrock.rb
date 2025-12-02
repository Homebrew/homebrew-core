class Shamrock < Formula
  desc "Astrophysical hydrodynamics using SYCL"
  homepage "https://github.com/Shamrock-code/Shamrock"
  url "https://github.com/Shamrock-code/Shamrock/releases/download/v2025.10.0/shamrock-2025.10.0.tar"
  sha256 "72683352d862d7b3d39568151a17ea78633bd4976a40eacb77098d3ef0ca3c55"
  license "CECILL-2.1"
  revision 1
  head "https://github.com/Shamrock-code/Shamrock.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "c47e9d92ac0748df6ae1b1a02ff190e4072323a79f0e5022ab970bf0a4c6f53a"
    sha256 arm64_sequoia: "0d83267cf6f83a883dd2a84dbb2be953422b482819843022f7ebe5ac52e7d98a"
    sha256 arm64_sonoma:  "013209e7ce2da835b1b16b345a521934e2075cda301a58a6e840c84a261575f6"
    sha256 sonoma:        "14e05876ef09736b68bf2ce5fb39efb449f63b7b503d83cd2c0b584e28329fba"
    sha256 arm64_linux:   "da7db3322a2330f9382b5a6bd28419b78fc2fd2c95f850ceed64a021452a124e"
    sha256 x86_64_linux:  "070d9694a2e302b0c4fc882cb8ab2bd473cb380c49ce74b5805cb3dcb83cbc80"
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

    py_package = site_packages(python).join("shamrock")

    mkdir_p py_package
    cp_r Dir["build/*.so"], py_package

    (py_package/"__init__.py").write <<~PY
      from .shamrock import *
    PY
  end

  test do
    system bin/"shamrock", "--help"
    system bin/"shamrock", "--smi"
    system "mpirun", "-n", "1", bin/"shamrock", "--smi"
    system python, "-c", "import shamrock"
  end
end
