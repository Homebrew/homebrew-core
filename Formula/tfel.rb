class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://github.com/thelfer/tfel/archive/refs/tags/TFEL-4.0.tar.gz"
  sha256 "ed3fb2f59c6b8c9896606ef92276f81942433dd5f60d8130ba07c3af80b039e2"
  license "GPL-1.0-or-later"
  head "https://github.com/thelfer/tfel.git", using: :git, branch: "master"

  bottle do
    sha256 arm64_monterey: "76becea0d88eda0120ab478674d1da58d06431229ca13f6fcbf1c3dd3cfa7f64"
    sha256 arm64_big_sur:  "4ca6638063893dab97dafd9b3cf92d8cac9496982c2579a2673513cfb9f15e1e"
    sha256 monterey:       "ef668e81efe8f87893df00bc96cb9fb2c2d2752d421b0b3d438cd41c4e5e1ec1"
    sha256 big_sur:        "3a41186585b769edf830702083d5ab36273d9c299587a024113b3053d293e75d"
    sha256 catalina:       "d9d2f38025e918e0cbff8064aa1983c621c1861fd8e8112a84624e70e81386c8"
    sha256 x86_64_linux:   "8250a622ef271143657e5087638906c959ba8a33bfc8398b3305b249e8c4af22"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "python@3.10" => :build
  fails_with gcc: "5"

  def install
    args = [
      "-DUSE_EXTERNAL_COMPILER_FLAGS=ON",
      "-Denable-reference-doc=OFF",
      "-Denable-website=OFF",
      "-Dlocal-castem-header=ON",
      "-Denable-python=ON",
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
