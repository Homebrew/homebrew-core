class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://github.com/thelfer/tfel/archive/refs/tags/TFEL-5.0.1.tar.gz"
  sha256 "820b2f9d54e237b2c2d9d6f06aaf7d4a1d3f34fb373e6549bee4fd8b55ecfad1"
  license "GPL-1.0-or-later"
  head "https://github.com/thelfer/tfel.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "5a32fde49de7f2ecb7019ceb8893ae34ecca6347c71b1598bc056199594d2014"
    sha256 arm64_sonoma:  "36ec43fdca67231f63225ca920b6f62e0e5489510de6c2b8796bc7238e6b42a4"
    sha256 arm64_ventura: "67632853027c9909241d22a4745db0c68ec235339713a51d0b626a443808578e"
    sha256 sonoma:        "ace78851845633b3f55a10cc49f7e365962b4acf5cee5c5a0e19ac35b5131226"
    sha256 ventura:       "b0a0492cfb359a04d65d9e7b0a4b41db3817ae492e002a5d58e712b682dce87c"
    sha256 arm64_linux:   "27e25c31a2fd4b106d35c072a359ccd78c478f42b52298d960d06a82ee877fc2"
    sha256 x86_64_linux:  "51420bbf165e34f3abdf34af61c445eadba23e9ca0ce8d1c092b0e0247a9cd16"
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
