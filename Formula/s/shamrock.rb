class Shamrock < Formula
  desc "Astrophysical hydrodynamics using SYCL"
  homepage "https://github.com/Shamrock-code/Shamrock"
  url "https://github.com/Shamrock-code/Shamrock/releases/download/v2025.05.0/shamrock-2025.05.0.tar"
  sha256 "59d5652467fd9453a65ae7b48e0c9b7d4162edc8df92e09d08dcc5275407a897"
  license "CECILL-2.1"
  head "https://github.com/Shamrock-code/Shamrock.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_sequoia: "996d6ea9bc4daa22a38d922a145a48acd22cc66672fdc2f0fe783ee09a6d6a9f"
    sha256 arm64_sonoma:  "b938862a15a7506af458f490c308167db0acea6c78d5c7ca2453e0d5bc394803"
    sha256 arm64_ventura: "dd30c19495510479bb8685688d763ba45d5d91fb10b4942627d1c0af6a1ed3c9"
    sha256 sonoma:        "6a7e28451a49e6cbb113288938dd702d2fba632014733ad731ea73c2daa153d8"
    sha256 ventura:       "f1fb942740b2635114c912785f46a4490da6cb35675ce58c2f9025748e99e7cc"
    sha256 arm64_linux:   "c45b56cd6956bcf249ba0e6ef106793c0ea0d9d8fe9cf3b947212cd1fbf295ea"
    sha256 x86_64_linux:  "90c5da30d8aae853303c544c5852bd14e024a7fbe4d18f6441edfc89b4b7fd54"
  end

  depends_on "cmake" => :build
  depends_on "adaptivecpp"
  depends_on "boost"
  depends_on "fmt"
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
    args = %W[
      -DSHAMROCK_ENABLE_BACKEND=SYCL
      -DPYTHON_EXECUTABLE=#{python}
      -DSYCL_IMPLEMENTATION=ACPPDirect
      -DCMAKE_CXX_COMPILER=acpp
      -DACPP_PATH=#{Formula["adaptivecpp"].opt_prefix}
      -DUSE_SYSTEM_FMTLIB=Yes
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
