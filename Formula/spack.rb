class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/v0.19.0.tar.gz"
  sha256 "b4225daf4f365a15caa58ef465d125b0d108ac5430b74d53ca4e807777943daf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4af2ffd6fa516f80ac77b276d50ed268cc48165ada4165d3254085cddef7730e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4af2ffd6fa516f80ac77b276d50ed268cc48165ada4165d3254085cddef7730e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4af2ffd6fa516f80ac77b276d50ed268cc48165ada4165d3254085cddef7730e"
    sha256 cellar: :any_skip_relocation, monterey:       "ec35b7ce41593c506dd2cbf2761de1863c45836501a1fa637a15c448e5da5f61"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec35b7ce41593c506dd2cbf2761de1863c45836501a1fa637a15c448e5da5f61"
    sha256 cellar: :any_skip_relocation, catalina:       "ec35b7ce41593c506dd2cbf2761de1863c45836501a1fa637a15c448e5da5f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8204003651c2b37f8d11d9ee4e7995ce1eb12584b9949dbfb2a68859f7a04a1"
  end

  uses_from_macos "python"

  def install
    rm Dir["bin/*.bat", "bin/*.ps1", "bin/haspywin.py"] # Remove Windows files.
    prefix.install Dir["*"]
  end

  def post_install
    mkdir_p prefix/"var/spack/junit-report" unless (prefix/"var/spack/junit-report").exist?
  end

  test do
    system bin/"spack", "--version"
    assert_match "zlib", shell_output("#{bin}/spack info zlib")
    system bin/"spack", "compiler", "find"
    expected = OS.mac? ? "clang" : "gcc"
    assert_match expected, shell_output("#{bin}/spack compiler list")
  end
end
