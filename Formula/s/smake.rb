class Smake < Formula
  desc "Portable make program with automake features"
  homepage "https://codeberg.org/schilytools/schilytools"
  url "https://codeberg.org/schilytools/schilytools/archive/2024-03-21.tar.gz"
  sha256 "4d66bf35a5bc2927248fac82266b56514fde07c1acda66f25b9c42ccff560a02"
  license "CDDL-1.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0049fe40e4b73f7f8c12607e2f1a6dec0547c73b0c0d7654585b4876edae939d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f89f5f1360c78408cedb0394404a92b6ef12dcd480b9f9fa7fc5a72ebdb3aeb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5f9615864ca5742016f51d7bd0e21059bf6f95a6bb3860b482681e9208efda1"
    sha256 cellar: :any_skip_relocation, sonoma:        "66fe816d0aa3c85c04859b5bbf81583a3b1bbcb897a3cb8b00a7de1c7aaef50d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffecd47d212b07d23f4c032e3ac9a5e0440e13a305eaccaff9b9b25c38bb1bb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bec844465d1f8b69f5b87ea582994f59c8385e310b926f7c7743acf6db587cd"
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
