class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2025.tar.gz"
  sha256 "ee2ac59c858ee41ef3ecf636b263464cac5895c0ee9c8f97b1aafca4b8b76350"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bd9cec0759bbce5f2a08aff4c75c3ee5179070cb057bb67509d73131c697f1b8"
    sha256 cellar: :any,                 arm64_sonoma:  "46d73d6adc639afbe0ccf046f0ee04565c0fa8ece4f255dbcc3fd084cebc8ab6"
    sha256 cellar: :any,                 arm64_ventura: "b626d60138ec38944c06be71c8dc60502b629fb1d59b719ac06e86037387f9b4"
    sha256 cellar: :any,                 sonoma:        "376f6f16fbd2f983349e7f6f0261283cf003fce002bd7c8ab784d7267e7d544f"
    sha256 cellar: :any,                 ventura:       "8869b98889a9da5d6f8c6977f99c48bdbc4766097fc22e57a67e3b4f931bc7c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be3143dd3a32d31d35b23f21933ceb8fe084df5516a47bea702526baf4fd5322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac6c4ab8c106fd9ea90c590381a6c79d5fb0199569c9b442704782c534f42feb"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "fftw"
  # add gromacs dep back once it was built with clang
  depends_on "hdf5"
  depends_on "libecpint"
  depends_on "libint"
  depends_on "libxc"

  uses_from_macos "expat"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = [
      "-DINSTALL_RC_FILES=OFF",
      "-DINSTALL_CSGAPPS=ON",
      "-DBUILD_XTP=ON",
      "-DCMAKE_DISABLE_FIND_PACKAGE_GROMACS=ON",
      "-DENABLE_RPATH_INJECT=ON",
      "-DPYrdkit_FOUND=OFF",
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
