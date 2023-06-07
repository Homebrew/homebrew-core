class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/v0.20.0.tar.gz"
  sha256 "a189b4e8173eefdf76617445125b329d912f730767048846c38c8a2637396a7d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "055156567773c2be5a98e28b5d161f199480fa60a0fedf6b04b60c2afd3dba92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "055156567773c2be5a98e28b5d161f199480fa60a0fedf6b04b60c2afd3dba92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "055156567773c2be5a98e28b5d161f199480fa60a0fedf6b04b60c2afd3dba92"
    sha256 cellar: :any_skip_relocation, ventura:        "53c1d31ad25dae2a66c6fa9a9842d66659f19ffe4190679839e32cb0cbc653bc"
    sha256 cellar: :any_skip_relocation, monterey:       "53c1d31ad25dae2a66c6fa9a9842d66659f19ffe4190679839e32cb0cbc653bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "53c1d31ad25dae2a66c6fa9a9842d66659f19ffe4190679839e32cb0cbc653bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0314777e3c63212048d0e9354476fb7f8c576c83a07d77cb7f6af59a2862fb3"
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
