class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  license "GPL-1.0-or-later"
  revision 1
  head "https://github.com/thelfer/tfel.git", branch: "master"

  stable do
    url "https://github.com/thelfer/tfel/archive/refs/tags/TFEL-5.0.0.tar.gz"
    sha256 "fe1ec39eba7f23571c2b0c773dab1cc274fee4512c5b2f2fc54b231da4502e87"

    # Backport fix for https://github.com/thelfer/tfel/issues/703
    patch do
      url "https://github.com/thelfer/tfel/commit/c4c564ab09a7c13c87ef3628ed89d2abe1c2aa0d.patch?full_index=1"
      sha256 "34b217330ef72b12d19b820a7edd994f0107e295f96c779dfe40a990528e1c3a"
    end
  end

  bottle do
    sha256 arm64_sequoia: "5f1c6d68fbfbfe5934ad3228edfb85923725bbb15733519edae03f98569bf66d"
    sha256 arm64_sonoma:  "1500133b1f232bf7b8436b5e6d540f0f76582c0b49b64e177b4012c7061599a5"
    sha256 arm64_ventura: "d2e37e3eecf517353ad9df9a47a92921aab78066867f7c897800fd4efd7f7676"
    sha256 sonoma:        "a64912de5088e357f13b2ace49fb391c707acaba8baf84682303ca4b3393df28"
    sha256 ventura:       "9d519e1e1fac5faa8b55d7ace4da8b0b7c289666bca34eeecb700d403d7d9a6b"
    sha256 arm64_linux:   "b4d8d0f32a885ef7b5777b0488a10ae576c9e4bd0c3b4f2eae054d82b4e6c3e5"
    sha256 x86_64_linux:  "399bd5e6c80879eb68cd9e92b717cd5ae745bb4432c2cdc177c0d1904c682591"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build # for gfortran
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
    # Avoid linkage to boost container and graph modules
    # Issue ref: https://github.com/boostorg/boost/issues/985
    args << "-DCMAKE_MODULE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.mfront").write <<~MFRONT
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
    MFRONT
    system bin/"mfront", "--obuild", "--interface=generic", "test.mfront"
    assert_path_exists testpath/"src"/shared_library("libBehaviour")
  end
end
