class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://github.com/thelfer/tfel/archive/refs/tags/TFEL-4.2.1.tar.gz"
  sha256 "14f27257014a992a4e511f35390e4b9a086f6a5ed74087f891f8c00306f1758f"
  license "GPL-1.0-or-later"
  revision 1
  head "https://github.com/thelfer/tfel.git", using: :git, branch: "master"

  bottle do
    sha256 arm64_sequoia:  "a1dbd6aedfae723113d626035fc3c0dd826006b409f4a0e02bbe844fc377ec43"
    sha256 arm64_sonoma:   "2c83f17aafe4803c5dcb76e75a1f0e065ddeb0c2a98cdde5284307c762850b73"
    sha256 arm64_ventura:  "e151a64d0af704275ff311cfef7d56d653d9ede613dc8f66b5ab44cf471d9afa"
    sha256 arm64_monterey: "349346beb4bc75a8275d72fc334d5788cf722d28675018259b61edebc9bd40e1"
    sha256 sonoma:         "8622ce53d1eba3091833e9d490ef783d28ff79a880cd7b067d3de70e3f6fcd00"
    sha256 ventura:        "f67f8d672f2eed887c9fb27db78f61bb5dfa6ae5275b9de38543e77c5d01e92c"
    sha256 monterey:       "b372fb99af0111007958b9bd88687e5cb9b67efb131888bd8b3ff55964974cb1"
    sha256 x86_64_linux:   "2d188e271109fa6cac8ef90708b3f3d4a83f20ec2d56b5d0fd99d14f7bad14c9"
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
