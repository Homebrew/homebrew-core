class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://github.com/thelfer/tfel/archive/refs/tags/TFEL-4.1.0.tar.gz"
  sha256 "7505c41da9df5fb3c281651ff29b58a18fd4d91b92f839322f0267269c5f1375"
  license "GPL-1.0-or-later"
  revision 1
  head "https://github.com/thelfer/tfel.git", using: :git, branch: "master"

  bottle do
    sha256 arm64_ventura:  "730f69c7daf530581f01c87b5e8934f938ae4a3585fe11c7adb33160de2568aa"
    sha256 arm64_monterey: "558bbbf8978f0fd1a81b672b1bfece19c5316dcb2dcf0a3a4bcbb5c2239d8bfe"
    sha256 arm64_big_sur:  "72a86416e1e0f9046d76d48aaa4688b23bf99c17ade8c05c5d113cd225bf89f6"
    sha256 ventura:        "5ad32922cad1b904726ba6689f5815d1100c0dbfc306afcfe5bb2ef9724143b0"
    sha256 monterey:       "9334e2f6d1fd4f688947b3c408aae56ec98510501c8eab2cbb2f3fb5210ec090"
    sha256 big_sur:        "9a4a31b1327e390840dc28eeba23284f4b1934f825194fc08975452489c00f58"
    sha256 x86_64_linux:   "c7507b59585685bdc7375a20c6b5f21e8b112594e791cea3095edc8d539895ce"
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
