class Smake < Formula
  desc "Portable make program with automake features"
  homepage "https://codeberg.org/schilytools/schilytools"
  url "https://codeberg.org/schilytools/schilytools/archive/2024-03-21.tar.gz"
  sha256 "fd3db00278caecd94b3802e1f903bf235a7137511ac0a450b31d855e3a52917b"
  license "CDDL-1.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b1fd1145026aeb8d563ea322f730f97c564f695e00c0f73f19f4a9e6f7df54c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b3634cb46c5afe31281f19421148a63f3dca44547d7ebea7033355d1676d43a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6e4b90da382898e0afa958537f4bbeb072930676a645db0c3040a199370b5e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d27ce4e6d1b94147edeba8cf7cfd625a5cfa952b5f04a5223272b416da8e3f2e"
    sha256 cellar: :any,                 arm64_linux:   "2826b7aa7fcfa905694233d576eb390011664a9c00f822a864571fa4d565053e"
    sha256 cellar: :any,                 x86_64_linux:  "7c7617f79ce36f8b4f05f475f712289b388da7b875f17c746ee9cae289a8d537"
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
    prefix.install "CDDL.Schily.txt"
  end

  test do
    system bin/"smake", "-version"
  end
end
