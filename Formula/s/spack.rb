class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "aef1a5ce16fe1a8bcced54c40012b19a0f4ade1cd9c5379aca081e96ec5b18ac"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "632ce5663f6b4868d4aef30a30420962adcd3ecba55805d225458e2f2ae341c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "632ce5663f6b4868d4aef30a30420962adcd3ecba55805d225458e2f2ae341c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "632ce5663f6b4868d4aef30a30420962adcd3ecba55805d225458e2f2ae341c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6739a45e0cfaa8da77918019d076cf39199ed08b7db5ed436e7eb60dc37b748"
    sha256 cellar: :any_skip_relocation, ventura:       "b6739a45e0cfaa8da77918019d076cf39199ed08b7db5ed436e7eb60dc37b748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cf3d6110e4504286c7bb0df44f5544b80cea8df3c9de00bdd8ca93a961ac1f5"
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
