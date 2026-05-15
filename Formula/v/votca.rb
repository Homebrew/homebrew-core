class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2026.tar.gz"
  sha256 "bf5827e93aecdfd040131ef8427f49efac4ea87d30882c2eb83fea16a054fbc8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "48327d11d3107d70c65c5e1bd1dd2e1e5209d6179e8c0df0f623ec22e29ad1a1"
    sha256 cellar: :any,                 arm64_sequoia: "2675954a5c9193d1cc46283914b8312ca4173edd4e34773cc14c3dd75ec9e2ad"
    sha256 cellar: :any,                 arm64_sonoma:  "7de2373e697dc6c25eb3c04c8c6b877a4172a423ecc67f3106abaa44cda216bf"
    sha256 cellar: :any,                 sonoma:        "53575de7b3f4627b382f0201874d3da6edc2f295a9151124c8b7553aa87ced39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7d9729f829ec9735fceffe634453a2eb822ff5e12f5638a76595fa30b71da07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "298b74dbe679bfbe6fcd723cff91d57588e1812abf73665b5b8379b0d3e0473c"
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
