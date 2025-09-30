class Smake < Formula
  desc "Portable make program with automake features"
  homepage "https://codeberg.org/schilytools/schilytools"
  url "https://codeberg.org/schilytools/schilytools/archive/2024-03-21.tar.gz"
  sha256 "4d66bf35a5bc2927248fac82266b56514fde07c1acda66f25b9c42ccff560a02"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "935c37ae0dc9258ccd97c8cf55851d91dd4c0ac1399fd138f61edec5dabf4306"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b2c9095c632a8c91be31c300a3a21234bc06c0cfec1772d9ca0af21a4230c69c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54d5687fe82a141e445b3e6bf8404dda343c41e57b0c67bc3292241b5af28d1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1f63df56d0dd8903164a3fa57dbf30b9d71904ddf051ef907e616e8b535da79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a88dc2fafc2b3f3745e1ad3a79e82c0c252faf403ff54a2f67e66298114e9ff4"
    sha256 cellar: :any_skip_relocation, sonoma:         "f46933438ba16e6944354e43afc1ed55572ded080b4267af8cb2e6fb7744107c"
    sha256 cellar: :any_skip_relocation, ventura:        "76c0564c658f45e7d92c1ffaaedf2b5394ace1f29a124867288a47575f40a339"
    sha256 cellar: :any_skip_relocation, monterey:       "8cf227992ec09344d3a74e81e4aa24b5c3b6747896bba6fdf8bc5b8ca55f57cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3f79e77a426444a0a251b6f839ea29f95a29552b912e660ccd21cf08c5a3a851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b51d8b0c121455fff0ae8f7b5329566f202885e5d4ca0a8720e9a42c489435f"
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
    system bin/"smake", "-version"
  end
end
