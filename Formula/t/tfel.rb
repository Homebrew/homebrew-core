class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://github.com/thelfer/tfel/archive/refs/tags/TFEL-5.0.1.tar.gz"
  sha256 "820b2f9d54e237b2c2d9d6f06aaf7d4a1d3f34fb373e6549bee4fd8b55ecfad1"
  license "GPL-1.0-or-later"
  revision 1
  head "https://github.com/thelfer/tfel.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "a32accc98e1a455f78c220aff9d3e20b7c0c082cf2132505771ff2889e75c188"
    sha256 arm64_sequoia: "e1e6e43f5a7be0c184226d0454e453e45ba3893fe36ba7550684e2f5d4e6bb92"
    sha256 arm64_sonoma:  "e0ab449a01ba8433286a4e521c2107e310c284df8acf444a6a734192157f12c0"
    sha256 arm64_ventura: "20d92835975863a877b1699fa2c3f74db629901b5c9a029de7d607171be99c7c"
    sha256 sonoma:        "7697db83e08a736da7840382d4c7f6e4a532cba3b22e45aefb0b94d4794ee42e"
    sha256 ventura:       "fffe0c9814cb14447b10b28a3f5fe7b24eeab1a55f00b8d5c1091783e7d1dc84"
    sha256 arm64_linux:   "53532c4a320aa267d7c05e0ff50e129a4897ce2fd917158bd4a94aec3b643e1e"
    sha256 x86_64_linux:  "08025fd560964c4888ea337e34f628dc94b9df184fae2b33ae830bf41537f7a1"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "boost-python3"
  depends_on "python@3.13"

  def install
    args = [
      "-DUSE_EXTERNAL_COMPILER_FLAGS=ON",
      "-Denable-reference-doc=OFF",
      "-Denable-website=OFF",
      "-Dlocal-castem-header=ON",
      "-Denable-python=ON",
      "-Denable-python-bindings=ON", # requires boost-python
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

    # Avoid linkage to boost container and graph modules
    # Issue ref: https://github.com/boostorg/boost/issues/985
    args << "-DCMAKE_MODULE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

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
