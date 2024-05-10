class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://github.com/thelfer/tfel/archive/refs/tags/TFEL-4.2.0.tar.gz"
  sha256 "cf8a309c4d19a8e36232f8540ff28aa0d6285645f8dfb1ac57dd481ba3453e02"
  license "GPL-1.0-or-later"
  revision 2
  head "https://github.com/thelfer/tfel.git", using: :git, branch: "master"

  bottle do
    sha256 arm64_sonoma:   "07fa908c948d7e6b6b27927a358672a996051c41521d1a7381fa25ea399c92fb"
    sha256 arm64_ventura:  "e0c694d2556c639aa9847d339941a1a0c1bcd7328613dace99bfcb4a9fa12299"
    sha256 arm64_monterey: "2b89eda277467ab1397de5d13a22a5cd517856d3fde218799d911a721adbaae3"
    sha256 sonoma:         "0d0c0eb2b704620c228df17fc1a7c0f504c5b7185a9bb94a87373a572ba6190a"
    sha256 ventura:        "bffcaee3219aa1331c491011b524d54efe63fdc94cd00604c146c15fc3819c1d"
    sha256 monterey:       "fba62321bc77dc57db5f25dcdf98be55330233534c91024b5f74ed3647b209f1"
    sha256 x86_64_linux:   "78e3bad40dd06b04b3683c26810c30949733d6015dd688220badd17c846a4788"
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
