class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/v0.17.0.tar.gz"
  sha256 "93df99256a892ceefb153d48e2080c01d18e58e27773da2c2a469063d67cb582"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4c6d9e6ca584976f41e4e0496b84730ada560fcc6766d8fde0afafdc1b6b0f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4c6d9e6ca584976f41e4e0496b84730ada560fcc6766d8fde0afafdc1b6b0f5"
    sha256 cellar: :any_skip_relocation, monterey:       "67ef975d666abc37d4838559895e7a28f95ba05a4d3a41988b381a056d7c438f"
    sha256 cellar: :any_skip_relocation, big_sur:        "67ef975d666abc37d4838559895e7a28f95ba05a4d3a41988b381a056d7c438f"
    sha256 cellar: :any_skip_relocation, catalina:       "67ef975d666abc37d4838559895e7a28f95ba05a4d3a41988b381a056d7c438f"
    sha256 cellar: :any_skip_relocation, mojave:         "67ef975d666abc37d4838559895e7a28f95ba05a4d3a41988b381a056d7c438f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c189fd21afa356d7a11b55fc4784ec245e221cd410f9c844a9a34bf7889282da"
  end

  depends_on "python@3.10"

  def install
    prefix.install Dir["*"]
  end

  def post_install
    mkdir_p prefix/"var/spack/junit-report" unless (prefix/"var/spack/junit-report").exist?
  end

  test do
    system bin/"spack", "--version"
    assert_match "zlib", shell_output("#{bin}/spack info zlib")
    on_macos do
      assert_match "clang", shell_output("spack compiler list")
    end
    on_linux do
      assert_match "gcc", shell_output("spack compiler list")
    end
  end
end
