class Shamrock < Formula
  desc "Astrophysical hydrodynamics using SYCL"
  homepage "https://github.com/Shamrock-code/Shamrock"
  url "https://github.com/Shamrock-code/Shamrock/releases/download/v2025.05.0/shamrock-2025.05.0.tar"
  sha256 "59d5652467fd9453a65ae7b48e0c9b7d4162edc8df92e09d08dcc5275407a897"
  license "CECILL-2.1"
  revision 1
  head "https://github.com/Shamrock-code/Shamrock.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "aa610358c555b050b5b2f8e63ff9ffa3490f097950e98c0fd2a4fdee6170e5d2"
    sha256 arm64_sequoia: "6687c40ab0b0822a689878016759da749b74b509f6cc87e97bf439f593e9bc21"
    sha256 arm64_sonoma:  "c306d2283e47c569a2e43eda7bada1a251e96e6d11192d4f38f7aed36559d5b5"
    sha256 arm64_ventura: "e27c1fde9845da8763005ce9b3fa6cc579f23ca1c73eaee98abfbe63d1908107"
    sha256 sonoma:        "7655ea9e18cf8cc48d4ee516b51b42596bd78e144e09287972352f03cc64f29c"
    sha256 ventura:       "66121774886d48bb65f150e6f3ec146b602ca1841603a943581f807381bf6483"
    sha256 arm64_linux:   "d922ccf350167168fc47e70a741bb6c3d53e100e4294af21b08dbb978cf5632e"
    sha256 x86_64_linux:  "babc28ee1a72de1e6d5b2418304e42d63c0009b7d5bea791bdaa7258a9524c9e"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pybind11" => :build
  depends_on "adaptivecpp"
  depends_on "boost"
  depends_on "open-mpi"
  depends_on "python@3.13"

  on_macos do
    depends_on "libomp"
  end

  def python
    which("python3.13")
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
    system "mpirun", "-n", "1", bin/"shamrock", "--smi", "--sycl-cfg", "auto:OpenMP"
    (testpath/"test.py").write <<~PY
      import shamrock
      shamrock.change_loglevel(125)
      shamrock.sys.init('0:0')
      shamrock.sys.close()
    PY
    system "python3.13", testpath/"test.py"
  end
end
