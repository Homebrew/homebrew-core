class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://github.com/thelfer/tfel/archive/refs/tags/TFEL-4.2.2.tar.gz"
  sha256 "021864ad5b27ffce1915bcacc8f39f3e8a72ce6bd32e80a61ea0998a060180e5"
  license "GPL-1.0-or-later"
  revision 2
  head "https://github.com/thelfer/tfel.git", using: :git, branch: "master"

  bottle do
    sha256 arm64_sequoia: "46bf238c2aa38c1ede704b6917f0807ae4a5476185d8f4524c041a3ee759e3f7"
    sha256 arm64_sonoma:  "b9efab41fc7ff12edad2c817fee8d77e8ddf49e58e4879fd4280672a7adb76b1"
    sha256 arm64_ventura: "6f40599f35dc778b08c063e53ff873974cc039e260727742ba1a06be381a2697"
    sha256 sonoma:        "5bae20c8304234ed4d6e32ae2e1d59a6bda2d5131c9fecd1a57f303a5f662104"
    sha256 ventura:       "d565d5a66446cb42cea96e3d43717843dc467effdd35da20feedd40af1bf92fe"
    sha256 x86_64_linux:  "f50822c3b76af3fc81d41e238eb5ce256f0588a30bcbb884399231253d977ce3"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
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
