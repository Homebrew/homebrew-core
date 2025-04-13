class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "32ca622c49448a3b4e398eb1397d8ff9a6aa987a248de621261e24e65f287593"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2684e22465a5d1dc2b6914046b3888ad551ba5e124854e3e67974330377e2bf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2684e22465a5d1dc2b6914046b3888ad551ba5e124854e3e67974330377e2bf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2684e22465a5d1dc2b6914046b3888ad551ba5e124854e3e67974330377e2bf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7624a31a3821c80a4c33f0e54e36fff5aa8f4c93e7d20b7a063205017cf50008"
    sha256 cellar: :any_skip_relocation, ventura:       "7624a31a3821c80a4c33f0e54e36fff5aa8f4c93e7d20b7a063205017cf50008"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94d27af942c129148f0f6638e22a029dc7090833fd4df88a13268e0c6303b21b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e86a9198a69c530a065637ceba3eb6d5133833879c406967deac53743659692b"
  end

  uses_from_macos "python"

  def install
    rm Dir["bin/*.bat", "bin/*.ps1", "bin/haspywin.py"] # Remove Windows files.
    rm "var/spack/repos/builtin/packages/patchelf/test/hello" # Remove pre-built test ELF
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
