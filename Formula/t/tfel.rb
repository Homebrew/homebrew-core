class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://github.com/thelfer/tfel/archive/refs/tags/TFEL-4.2.0.tar.gz"
  sha256 "cf8a309c4d19a8e36232f8540ff28aa0d6285645f8dfb1ac57dd481ba3453e02"
  license "GPL-1.0-or-later"
  head "https://github.com/thelfer/tfel.git", using: :git, branch: "master"

  bottle do
    sha256 arm64_sonoma:   "d01437e12eec1367c3385d6b3f5466275cec9925c8bc3fab281ee7467b87d1b5"
    sha256 arm64_ventura:  "78e5efcaadb1e224810b506f6f9ad54d8e5bf20af677f2a7fc69e0e120fc3418"
    sha256 arm64_monterey: "86d56d9b167b27a039cb28cb798fa0371648c8793a601286f3d73aace4bc2bc8"
    sha256 sonoma:         "33e53b06b98c0a265e2eeebb61b9c49f9a8701fd28ad676699c38b61b0f59d37"
    sha256 ventura:        "2c18ed0b137a3d0b2ebcf07cbc331ed769cb6a5e3fd1d246eb89bc4b52089fd5"
    sha256 monterey:       "5491f70484caa33cbd0c0dfe37e9809c4abad539ee8cb94d6a7d797ab834e9dd"
    sha256 x86_64_linux:   "06ce42291e3ac850e25d359e595278138f8a09695771b707451a84ee00ace313"
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
