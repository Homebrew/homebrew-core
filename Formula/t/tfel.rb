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

    # Backport fix for https://github.com/thelfer/tfel/issues/740
    patch do
      url "https://github.com/thelfer/tfel/commit/331f889bec18329d2a8770cf72be33218c39b3f7.patch?full_index=1"
      sha256 "901c94fe0a48890e4b17d6cefd87dde34dead3563544162b3196aacda04eebc0"
    end
    patch do
      url "https://github.com/thelfer/tfel/commit/2ac23026e15c716c8b5364aa572fb651457ad786.patch?full_index=1"
      sha256 "8becb7f82848cb36dd2fc200bed676c95692c9a451ca12c661ef1374ba87bbf1"
    end
  end

  bottle do
    sha256 arm64_sequoia: "50d3bd7962505ed2bc6fb2557947d7ec078167ac5d5e6525bb1ec644ab69514b"
    sha256 arm64_sonoma:  "348823d0f7433600de4005ec4bc423d18e46c1eabf43bf743eef83b9fc802bd4"
    sha256 arm64_ventura: "6faecb90a644d46af6d4d8d0a2e1619b4abc21f479af6c81e532e3393c6b129c"
    sha256 sonoma:        "f21cf45477369903801db72624265e799e8fe24a1d53231f61eb6bee33ee1516"
    sha256 ventura:       "2fc7f26b7cfc67188891020563e4b96ddc8945b924532b1512199b3029e00076"
    sha256 arm64_linux:   "a70c7ba818b14efbe76d4a02762fed0625f78bd8906d4978dd2f1d27c2bd5c3e"
    sha256 x86_64_linux:  "5086c2c9498895965149d37772fb2a4ef7f06cbb1071d3d31291e678b42f9f1c"
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
      "-Denable-testing=OFF",
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
