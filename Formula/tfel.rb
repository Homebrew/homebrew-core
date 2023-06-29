class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://github.com/thelfer/tfel/archive/refs/tags/TFEL-4.1.0.tar.gz"
  sha256 "7505c41da9df5fb3c281651ff29b58a18fd4d91b92f839322f0267269c5f1375"
  license "GPL-1.0-or-later"
  revision 2
  head "https://github.com/thelfer/tfel.git", using: :git, branch: "master"

  bottle do
    sha256 arm64_ventura:  "e7a36c0e5e16ea86948fac8e6dbe5154280e92762d005c502ae67d78c2266752"
    sha256 arm64_monterey: "e2bacd1722df002e836c893028af2ba0a2889f09809eb494243f6c63f1dd7eb2"
    sha256 arm64_big_sur:  "14369581648f19f2c106dc318180182b6bae6334e31976cfc21f4ce5c13e8769"
    sha256 ventura:        "d461a7949788f856112f39cec75dfb45c71e76c194eadf3d58a08d092aa87a57"
    sha256 monterey:       "a9041744c78a7c6d157979493cf8685b55b2a0ed5ad0e246664c8e67cb53d586"
    sha256 big_sur:        "bdf5e24ae4870225ac84ffeff3fd3891711b40837dc0c8c0180928f83041ffa7"
    sha256 x86_64_linux:   "bd95038005351e47768c896557df3e8c95bdc75fe764a3d3badec12af9f01ef9"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "boost-python3"
  depends_on "python@3.11"
  fails_with gcc: "5"

  def install
    args = [
      "-DUSE_EXTERNAL_COMPILER_FLAGS=ON",
      "-Denable-reference-doc=OFF",
      "-Denable-website=OFF",
      "-Dlocal-castem-header=ON",
      "-Denable-python=ON",
      "-Denable-python-bindings=ON",  # requires boost-python
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
      "-Dpython-static-interpreter-workaround=ON",

    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.mfront").write <<~EOS
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
    EOS
    system bin/"mfront", "--obuild", "--interface=generic", "test.mfront"
    assert_predicate testpath/"src"/shared_library("libBehaviour"), :exist?
  end
end
