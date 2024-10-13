class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2024.2.tar.gz"
  sha256 "704d50f64bbfa2e19d0aa4b5726ac35c20c3b9b45554be5f1e1417d430e31c24"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c851db85234aa35aa9155aaa4872a04aa58324f08fbb47bc3788541792b1d661"
    sha256 cellar: :any,                 arm64_sonoma:  "ec44f7aac765b4b81260bcc1de2ea076b4b78c2dfa4bf7d993da8c74335bf2bc"
    sha256 cellar: :any,                 arm64_ventura: "1c9dbd430fc9300fcc282269f596cada4beb8839ce7446dcde32194da234e3bc"
    sha256 cellar: :any,                 sonoma:        "eef20cb56c41ed7c1d2413cdeaa5a4f9f3726e97798697cf601621a65d862f35"
    sha256 cellar: :any,                 ventura:       "52dbdf32d36464cbc1bfc044246ca8f981410c9ecbf31e6b1e7e6f5eaaadc78e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f4703fa99a47953c9648d617c618b4b810b768607225f5acec6b4f0e1a8ce99"
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
