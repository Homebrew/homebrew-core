class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2025.1.tar.gz"
  sha256 "85b487d2b2a31f26869be422c98f816b95c88a4ab112ea4650cccd4c2706bdbf"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fded17617f5140a20b04b5cfc9281e6429380d175d4e055a3d6b4dcc52a85b57"
    sha256 cellar: :any,                 arm64_sequoia: "1cf98138786201b215734a1211d11cf41966ff3dce3d488b048628576236d4db"
    sha256 cellar: :any,                 arm64_sonoma:  "4b16956c81ad38c7f4a48867d10f1e08e7b1c18018b47440d7b040a5fc48397b"
    sha256 cellar: :any,                 sonoma:        "ae0f8523a835692c893098181ad612b727c3f0ada15d6d7d29f5cf0227f854c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6599a17075e452492e0f9266812795c28c724103e97c58563058d8d2b436217d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab37fef79c54edc8f175901834c1d6a6017029943f52c33d308e34fda97d67a3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
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

  # Apply open PR to support eigen 5.0.0
  # PR ref: https://github.com/votca/votca/pull/1189
  patch do
    url "https://github.com/votca/votca/commit/cc581d91196c3505c649e35ba69bcc8ec33fa14b.patch?full_index=1"
    sha256 "08da2d4fd694eb1b3909fe4ef452b042a0b0733ca5d8b68e0e655b09842cb069"
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
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
