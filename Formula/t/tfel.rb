class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://github.com/thelfer/tfel/archive/refs/tags/TFEL-4.2.1.tar.gz"
  sha256 "14f27257014a992a4e511f35390e4b9a086f6a5ed74087f891f8c00306f1758f"
  license "GPL-1.0-or-later"
  head "https://github.com/thelfer/tfel.git", using: :git, branch: "master"

  bottle do
    sha256 arm64_sonoma:   "cb36d0506055650920db939f3e87a978dab2bec265b8140ed3772a1c85d80a59"
    sha256 arm64_ventura:  "42dfba6fe15040f587f144fd846496ae3b71b677fe8a2d03e50cc3e75327882c"
    sha256 arm64_monterey: "b0809b93eecab7dac90b8c2cee91f7edbc70b720f5fdb9ab4f6943fdf68e28c1"
    sha256 sonoma:         "56a6c8012212df0257ec9d6a054c7d86cb9f20b29a3d262ad0c29e259555c1cf"
    sha256 ventura:        "a8ab10d3ea152f2fff777f969180d3f18d9469fd14d4cac912f38a02b12b8259"
    sha256 monterey:       "6d0654f25e5a7fa4893a5ab4307b3e17a86192a7530cb2973c3331e0a3ac63f6"
    sha256 x86_64_linux:   "ce7346f2ba72a463e6345f7f97448fd60fe14f2fe1bdc746e82b12310bd4e0a3"
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
