class Smake < Formula
  desc "Portable make program with automake features"
  homepage "https://codeberg.org/schilytools/schilytools"
  url "https://codeberg.org/schilytools/schilytools/archive/2023-09-28.tar.gz"
  sha256 "564ea2365876a53eba02f184c565016399aee188c26d862589906cf3f92198e6"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a4418c3ef6f5610a6dacc7b183b5321d6c8f7640bde302834de3976b740f656"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10387f273afd34a0dadac4e3e9b1636d4de32a144bc1765d2adfc33ae0b6aaff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7da20f411b28f423f8ca433b422a7cfe2e72088da768627083a41bb1aa1f08fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "72525dff8c40cb69a8ec875db129d4058844ea5a19c2d2a99bffde4ed113b233"
    sha256 cellar: :any_skip_relocation, ventura:        "fd38d6c5cebdb8d46fa51fd6611121509a1b951d01ca5e74c9a51f1bad664885"
    sha256 cellar: :any_skip_relocation, monterey:       "9347048609932ebb17d63fc70b2419e8f1c09002b90b6c49c4ca401420514cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36cd46c6d1b8bd14693770c74b9fe54632ab8f451a325aba125bc9d6eca9b162"
  end

  def install
    cd "psmake" do
      system "./MAKE-all"
    end

    cd "libschily" do
      system "../psmake/smake"
    end

    cd "smake" do
      system "../psmake/smake"
    end

    cd "man" do
      system "../psmake/smake"
    end

    bin.install Dir.glob("smake/OBJ/*/smake")
    man1.install Dir.glob("smake/OBJ/*/*/*.1")
    man5.install Dir.glob("man/man5/OBJ/*/*/*.5")
  end

  test do
    system "#{bin}/smake", "-version"
  end
end
