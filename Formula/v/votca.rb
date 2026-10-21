class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2026.tar.gz"
  sha256 "bf5827e93aecdfd040131ef8427f49efac4ea87d30882c2eb83fea16a054fbc8"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "8843069deb25ea8cbb65f1bd99f8e8528f4fd71a421aef90d0ca0ab872677e18"
    sha256 cellar: :any, arm64_tahoe:       "f264b49374e4e87cf2ee83d9dc9b7c83558da3de7376d6e3a26f834240efa98e"
    sha256 cellar: :any, arm64_sequoia:     "e2bd52073625eae2a3900b6228909ab1a165d7b0536faaf282277ad789f7bac9"
    sha256 cellar: :any, arm64_linux:       "9bc7d4f514f657d4188e9abcc350e96870060bac14d7561893d4851164eb0209"
    sha256 cellar: :any, x86_64_linux:      "f8b83cffcc8124261fc5c82df40412950f87d1f8766d542c2ff063d81abc89d9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15" => :build
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
