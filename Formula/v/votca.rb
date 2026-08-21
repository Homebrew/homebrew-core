class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2026.tar.gz"
  sha256 "bf5827e93aecdfd040131ef8427f49efac4ea87d30882c2eb83fea16a054fbc8"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aeaa3a7b5afff53fc262120ebce590968af269592cc06454246116cd26fa7ae3"
    sha256 cellar: :any, arm64_sequoia: "eb91e1a25d0e7f44909fc1c39aac058af977b231808ee52849dc7499394ec475"
    sha256 cellar: :any, arm64_sonoma:  "40da070d2b8b28fcc36ac31f7725ec83e5cffef3d2da30730ecc8e17ae6bf018"
    sha256 cellar: :any, sonoma:        "df56431fa544e44f964c51294f3a74b4dbc91aa743dd9b9bb7ecc98d0e5bb83a"
    sha256 cellar: :any, arm64_linux:   "8151ecd3a29e92cd09bb1832b14c8ae818e5e0f39b9304343690bb127eff82ec"
    sha256 cellar: :any, x86_64_linux:  "ef0dccb6dcee6ad8e7bf6cdd719cf671cbbd72a95e9a4ffbde483e9e6f7bb7d8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "boost"
  depends_on "eigen" => :no_linkage
  depends_on "fftw"
  depends_on "gromacs"
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
      "-DENABLE_RPATH_INJECT=ON",
      "-DPYrdkit_FOUND=OFF",
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"topol.xml").write <<~XML
      <topology>
        <molecules>
          <molecule name="MOL" nmols="1" nbeads="1">
            <bead name="B" type="B" mass="1.0" q="0.0" resid="1"/>
          </molecule>
        </molecules>
      </topology>
    XML

    output = shell_output("#{bin}/csg_dump --top topol.xml")
    assert_match "I have 1 beads in 1 molecules", output
  end
end
