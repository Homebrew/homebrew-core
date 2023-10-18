class Smake < Formula
  desc "Portable make program with automake features"
  homepage "https://s-make.sourceforge.net/"
  url "https://codeberg.org/schilytools/schilytools/archive/2023-09-28.tar.gz"
  version "1.7-2023-09-28"
  sha256 "564ea2365876a53eba02f184c565016399aee188c26d862589906cf3f92198e6"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f96bcc9d691106585693783553b709cf4366170f1dadfbe76121e22eb94a2f2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "090a8a9be4f73f219b85f283f833de8336d8009418c64195cc6aba8599a96889"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3710a51c46dead615576fa397995c278615e2cb7e094678da14a41906a7eebc"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e51561e230f171753c2d163ed67ebba865fafeeca559f514c98a18b9e358b34"
    sha256 cellar: :any_skip_relocation, ventura:        "15cd5351102ca3e6b5b93fe36e3c92d4e88015175077ffafacd182b54284c33c"
    sha256 cellar: :any_skip_relocation, monterey:       "43af100fd2db88ded7bb3d9628b9b7b2d786458f7b698448287b597353aa9918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d6cf53c6412f3e5e5ae1ba150ca4f3f54624bd8ecc5ef9dc5ada42c4f59ded1"
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
