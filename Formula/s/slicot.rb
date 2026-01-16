class Slicot < Formula
  desc "Fortran subroutines library for systems and control"
  homepage "https://www.slicot.org/"
  url "https://github.com/SLICOT/SLICOT-Reference/releases/download/v5.9.1/slicot-5.9.1.tar.gz"
  sha256 "0f812933a07577db8c80dc53fc3663844114d43880f4c2fb383622891e931504"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe100cde167f2c093216156513328bb28f2a4c7ea5258c266cfc10d467bf59a2"
    sha256 cellar: :any,                 arm64_sequoia: "f6871a8005e9bf5d72a32d14443624a914027946644bcd945f3e0cc4f3f573a9"
    sha256 cellar: :any,                 arm64_sonoma:  "66ed2195520bfa80e07b7956f0b3d8e698b62702deba9960876f6a28c1de44b5"
    sha256 cellar: :any,                 sonoma:        "e1686e0f706660d9fed58f3e75a2c89d8ef729f0b6a0c32ba6c27df8371bf743"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d5b8da792e3ef6cc877f3378cf09363e506a8f0343e2979d3119fb753859e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ea5b7ec7913b21537a1372ee5644e9eb7fd2f70466c8b8a914a1cf82b589b41"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DSLICOT_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Using a test without 0.0000 which can fail from sign swapping to -0.0000
    pkgshare.install "examples/TAB05RD.f", "examples/data/AB05RD.dat", "examples/results/AB05RD.res"
  end

  test do
    system "gfortran", "-o", "test", pkgshare/"TAB05RD.f",
                       "-L#{lib}", "-lslicot", "-L#{Formula["openblas"].opt_lib}", "-lopenblas"
    assert_equal (pkgshare/"AB05RD.res").read, pipe_output("./test", (pkgshare/"AB05RD.dat").read, 0)
  end
end
