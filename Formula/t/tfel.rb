class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://github.com/thelfer/tfel/archive/refs/tags/TFEL-4.2.0.tar.gz"
  sha256 "cf8a309c4d19a8e36232f8540ff28aa0d6285645f8dfb1ac57dd481ba3453e02"
  license "GPL-1.0-or-later"
  revision 1
  head "https://github.com/thelfer/tfel.git", using: :git, branch: "master"

  bottle do
    sha256 arm64_sonoma:   "b02a5aeb285a83a9ab5a9a6e71d35150ad9b8fabcf580277705e9621f43a0528"
    sha256 arm64_ventura:  "d4fe36a11d065b61b3abba0407b1e0581bbcd662ec5dd45ec7cdd65939202753"
    sha256 arm64_monterey: "17e3bd76b2adc4fa6cb052404571da9e05a81ed3c4b62f0400838e5b1c817824"
    sha256 sonoma:         "cc9749378a2e74e66505fe5218ad752abd445efbfd6ad664eede65529fde96a1"
    sha256 ventura:        "f98c07cafabd508ade1421df78ca33f956ca9a3d3d55f5c77c64f1aae3edea1d"
    sha256 monterey:       "4b5c82e9280af6faa77a534467dcab7bae14ca833721e24772e9fd4818176f1f"
    sha256 x86_64_linux:   "6247ccab9ce4bbb59e433b0170fc8679be7f2b21b6b5fb6552e916386de128e3"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "boost-python3"
  depends_on "python@3.12"
  fails_with gcc: "5"

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
