class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "b1860537ba00c55fa0b2517ce9dbfe0e415600892c48e3dc4e15ee8da0f50dd3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad5a93d8b08967106e0b99e2b6ae1141965435bb5b90ac7030344498964d09e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad5a93d8b08967106e0b99e2b6ae1141965435bb5b90ac7030344498964d09e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad5a93d8b08967106e0b99e2b6ae1141965435bb5b90ac7030344498964d09e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8576d9d37391c3ca7fbff01374afe2c65dfe87de044f6ca51502b3bd4140449"
    sha256 cellar: :any_skip_relocation, ventura:        "e8576d9d37391c3ca7fbff01374afe2c65dfe87de044f6ca51502b3bd4140449"
    sha256 cellar: :any_skip_relocation, monterey:       "e8576d9d37391c3ca7fbff01374afe2c65dfe87de044f6ca51502b3bd4140449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db94daee63fd24bbca952833c950b8d8add01ac0828b1b79aab07dc58ace6c4c"
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
