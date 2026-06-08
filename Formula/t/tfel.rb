class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://github.com/thelfer/tfel/archive/refs/tags/TFEL-5.1.0.tar.gz"
  sha256 "1afd98200de332e97e86d109ce0e1aaa8f18cc6c6c81daec3218809509cdfad7"
  license "GPL-1.0-or-later"
  head "https://github.com/thelfer/tfel.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "6c176029b0f9a9a97eba1a77309303a6e21d06f9b732dd36b21a6a906c0af94e"
    sha256 arm64_sequoia: "c6df35305057ba120a952044049c3b11ec4036453ed0bfe6034ba3ee998b0677"
    sha256 arm64_sonoma:  "2af5946f1175cfd3ee7e78b27ecca53257c45128b71782bc08692a6c6280965e"
    sha256 sonoma:        "24947bbb4aa4789ba475114643e7e27301d1c5848963dc79f3cf2c6f827cb2d0"
    sha256 arm64_linux:   "b0a9c7bbfe1fde48bd5bc46a8504dd1b1337063ab86e215779b3367f9f634607"
    sha256 x86_64_linux:  "bb7e42bbd5f89718c0be51a12c9ab0af0236dd1bdbdc4eb6a7e48a633d144949"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "pybind11" => :build
  depends_on "python@3.14"

  def install
    args = [
      "-DUSE_EXTERNAL_COMPILER_FLAGS=ON",
      "-Denable-reference-doc=OFF",
      "-Denable-website=OFF",
      "-Dlocal-castem-header=ON",
      "-Denable-python=ON",
      "-Denable-python-bindings=ON",
      "-Denable-pybind11=ON", # requires pybind11
      "-Denable-numpy-support=OFF",
      "-Denable-fortran=ON",
      "-Denable-cyrano=ON",
      "-Denable-lsdyna=ON",
      "-Denable-aster=ON",
      "-Denable-abaqus=ON",
      "-Denable-calculix=ON",
      "-Denable-comsol=ON",
      "-Denable-diana-fea=ON",
      "-Denable-ansys=ON",
      "-Denable-europlexus=ON",
      "-Denable-testing=OFF",
      "-Dpython-static-interpreter-workaround=ON",
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.mfront").write <<~MFRONT
      @Parser Implicit;
      @Behaviour Norton;
      @Algorithm NewtonRaphson_NumericalJacobian ;
      @RequireStiffnessTensor;
      @MaterialProperty real A;
      @MaterialProperty real m;
      @StateVariable real p ;
      @ComputeStress{
        sig = D*eel ;
      }
      @Integrator{
        real seq = sigmaeq(sig) ;
        Stensor n = Stensor(0.) ;
        if(seq > 1.e-12){
          n = 1.5*deviator(sig)/seq ;
        }
        feel += dp*n-deto ;
        fp -= dt*A*pow(seq,m) ;
      }
    MFRONT
    system bin/"mfront", "--obuild", "--interface=generic", "test.mfront"
    assert_path_exists testpath/"src"/shared_library("libBehaviour")
  end
end
