class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.8.2.tar.gz"
  sha256 "996c48c87baaeb5fc04bd85c7e66d3651a56fe749c531c60926d75b4db5d2181"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "Apache-2.0",
    "GPL-3.0-only",
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"],
  ]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia:  "8ec27332cf3d94f7ccd5d7b01281b5dc9398f62348ab3af29bd670339c06651b"
    sha256                               arm64_sonoma:   "101c0d93d13fb9779565f3b02eb13089af399dfbc6a4d01a4e12e596a78c1e92"
    sha256                               arm64_ventura:  "4227902ef74ebd8f3251d05a1ddce2237be3a3fed21979029294c35c96807565"
    sha256                               arm64_monterey: "f95bbc949b8a8e956b17dad87e1fcb580cc85a66d8ee48f0cd9fd44d466288cd"
    sha256                               sonoma:         "f4d12773156e3db86538c5187d9297728ced5a07f2ffc30f87dee8eb892cdd04"
    sha256                               ventura:        "45e042e8e1d97e4f8da55939a078b964dc90004ceed67a5841c205a8aab3368b"
    sha256                               monterey:       "d953801a4d4ceac93cf02900a2c5bb880874990a165509d632079ff4b77d5e5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ebd77d25fde68e00e37510b56cb6bf6b67dd895d8775a648a19f54e059a51d9"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "metis"
  depends_on "mpfr"

  uses_from_macos "m4"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    # Avoid references to Homebrew shims
    if OS.mac?
      inreplace "GraphBLAS/cmake_modules/GraphBLAS_JIT_configure.cmake",
          "C_COMPILER_BINARY \"${CMAKE_C_COMPILER}\"", "C_COMPILER_BINARY \"#{ENV.cc}\""
    end

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "KLU/Demo/klu_simple.c"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"klu_simple.c",
                   "-I#{include}/suitesparse", "-L#{lib}",
                   "-lsuitesparseconfig", "-lklu"
    assert_predicate testpath/"test", :exist?
    assert_match "x [0] = 1", shell_output("./test")
  end
end
