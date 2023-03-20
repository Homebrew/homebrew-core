class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://github.com/thelfer/tfel/archive/refs/tags/TFEL-4.1.0.tar.gz"
  sha256 "7505c41da9df5fb3c281651ff29b58a18fd4d91b92f839322f0267269c5f1375"
  license "GPL-1.0-or-later"
  revision 1
  head "https://github.com/thelfer/tfel.git", using: :git, branch: "master"

  bottle do
    sha256 arm64_ventura:  "7f9faf03cb651a5a537f142f4888b2e35f334ff3be73c7fb052ad7e0cd8c7987"
    sha256 arm64_monterey: "8bf742def68aa4dff762e70d4233ca444bb322729c5e6fff712c459df8406c42"
    sha256 arm64_big_sur:  "fc16133e08021a0d31be63b2b9baa03adabcca71b1f9910dd265659c77997e6c"
    sha256 ventura:        "53911120787bc37d8420ff9d6aafba53ce687b41bc869e298dc11fc9a4046be2"
    sha256 monterey:       "b91b8c62831b55fa2d7dddda65c643141f37de14e4125422c6897a4a8254509f"
    sha256 big_sur:        "7b2b4837da1a949b8ed0d216222eb8aea028908ddf6ad2b74c182c08b8188772"
    sha256 x86_64_linux:   "591bde34d7eb5c1fa0d2b160a4a4a4de610762c1cf6e57c81c57c532aa1351f5"
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
    system "mfront", "--obuild", "--interface=generic", "test.mfront"
    assert_predicate testpath/"src"/shared_library("libBehaviour"), :exist?
  end
end
