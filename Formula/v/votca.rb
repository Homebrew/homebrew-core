class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2024.1.tar.gz"
  sha256 "74d447f976a7d5c05ec65ab99f52b75379cafa3b40b8bc3b9b328f8402bc53dc"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "99fedc9b85634f468a7e4682910f80741540ec142a76dc25a6274abbbadd11ce"
    sha256 cellar: :any,                 arm64_ventura:  "24f0bb5d366aa024007b616564143df01cfdfc912441e8011e036974ab2c8273"
    sha256 cellar: :any,                 arm64_monterey: "82184cadf874cc9cce63f290f5a7c035938d8f731632b113eb38546fadcb94cc"
    sha256 cellar: :any,                 sonoma:         "bf88a4c0818a02a027791f1b786014ea8615597c1b4bc461d370270ba2f91d51"
    sha256 cellar: :any,                 ventura:        "66f200ae21a2fe9ff8b524bebc36cb52d2af1f4e29d6565830585db5f1f7d1a0"
    sha256 cellar: :any,                 monterey:       "5d8b58ac3e94b1d33aca9ad48c218a2ef112cc6466749daf4801d3b0acced78a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c698934a60c802666b3466925e19e85019410e4d67fc648192a189a77cc9241"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  # add gromacs dep back once it was built with clang
  depends_on "hdf5"
  depends_on "libecpint"
  depends_on "libint"
  depends_on "libxc"
  depends_on "numpy"
  depends_on "python@3.12"

  uses_from_macos "expat"

  on_macos do
    depends_on "libaec"
    depends_on "libomp"
  end

  def install
    args = [
      "-DINSTALL_RC_FILES=OFF",
      "-DINSTALL_CSGAPPS=ON",
      "-DBUILD_XTP=ON",
      "-DCMAKE_DISABLE_FIND_PACKAGE_GROMACS=ON",
      "-DENABLE_RPATH_INJECT=ON",
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"csg_property", "--help"
    (testpath/"table.in").write <<~EOS
      0 0 i
      1 1 i
    EOS
    system bin/"csg_resample", "--in", "table.in", "--out", "table.out", "--grid", "0:0.1:1", "--type", "linear"
    assert_path_exists "#{testpath}/table.out"
  end
end
