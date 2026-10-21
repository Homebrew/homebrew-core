class Shamrock < Formula
  desc "Astrophysical hydrodynamics using SYCL"
  homepage "https://shamrock-code.github.io"
  url "https://github.com/Shamrock-code/Shamrock/releases/download/v2025.10.0/shamrock-2025.10.0.tar"
  sha256 "72683352d862d7b3d39568151a17ea78633bd4976a40eacb77098d3ef0ca3c55"
  license "CECILL-2.1"
  revision 1
  head "https://github.com/Shamrock-code/Shamrock.git", branch: "main"

  bottle do
    rebuild 2
    sha256 arm64_golden_gate: "20b3248e2d09c13d4226bae93eae26a932a3329bdd7c8db5fbe70abda103d23d"
    sha256 arm64_tahoe:       "f131a097feca0ac1423962079dff9fe825bb84a872696439d5489cda430033de"
    sha256 arm64_sequoia:     "bd6e2d36e0e696849829afb4e4d8b209db2d9b75adb4acd9c37d6e9fc2d7e83d"
    sha256 arm64_linux:       "fa2d55716aa506e01cb0e1ae1858941fe70791a44584c89ab3fcc50f08c76c95"
    sha256 x86_64_linux:      "68345e9dd1ed4e67fe9d8b3254377cd300727754528940f6e0aafe0241634a89"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pybind11" => :build
  depends_on "adaptivecpp"
  depends_on "open-mpi"
  depends_on "python@3.15"

  on_macos do
    depends_on "libomp"
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
      -DPYTHON_EXECUTABLE=#{python3}
      -DCMAKE_INSTALL_PYTHONDIR=#{site_packages(python3)}
      -DSYCL_IMPLEMENTATION=ACPPDirect
      -DCMAKE_CXX_COMPILER=acpp
      -DACPP_PATH=#{formula_opt_prefix("adaptivecpp")}
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
    system python3, "-c", "import shamrock"
  end
end
