class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "81d0d25ba022d5a8b2f4852cefced92743fe0cae8c18a54e82bd0ec67ee96cac"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96654b9f215e1c6f0c596eb488ba86008f668ac0616fc1747d59a4c3dde2e5c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8263d78350eeb7589be31b32feeb0a95f08bb3b9fec7f09e59d31f76d58292d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bd7560bc1c279bde46f42bc5321849ec32702dcbf77d17e488aca5dca7bbe9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9936a556df300d720d386f4b381d3615e208e039fb228f34c6ae152d903ebaa"
    sha256 cellar: :any_skip_relocation, ventura:        "637cf09e813706af2b3fa8de0f7c9da9551925483ad607123ba94b0ed66f4fb4"
    sha256 cellar: :any_skip_relocation, monterey:       "6a0501e7e92ec533b8c04b479a8b322a3667c77823951ada69951be530b17bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "848b14023f84044133ad21438f3a472d34baeee1e45523ee31d478daa8449911"
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
