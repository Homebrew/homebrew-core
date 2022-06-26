class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/v0.5.2.tar.gz"
  sha256 "29172a43c7a4f41e5809d8c40cb76b798a0d01dfc9f5340b160a405b89b3b182"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e505b8cbcbd0616827dd30b6f721d22934033035245298eb38ccbc068826845d"
    sha256 cellar: :any,                 arm64_big_sur:  "8bcf6b7c935fb4a1e16ab5d4aeb17ed219326eb4a0af16d29a0c8b0df7a23cb4"
    sha256 cellar: :any,                 monterey:       "48ac9ac9428dfcc172424bcbb38b54513ba771862f1213bed99103b99d8adca3"
    sha256 cellar: :any,                 big_sur:        "c437b7d82e464e25d20f9e68520afe1e9af9bb9f541947c81249803a30464cca"
    sha256 cellar: :any,                 catalina:       "36d32f696c7cd52e92a5fc6fa61684f2672bf4f68fbabde56ad738ce8d2531aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03516bc2b7b6c848d9e0caa8d32802da53cc226901ece9eddd1b1e49e1833af9"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpng"

  resource "rgbobj" do
    url "https://github.com/gbdev/rgbobj/archive/refs/tags/v0.1.0.tar.gz"
    sha256 "359a3504dc5a5f7812dfee602a23aec80163d1d9ec13f713645b5495aeef2a9b"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "mandir=#{man}"
    resource("rgbobj").stage do
      system "cargo", "install", *std_cargo_args
      man1.install "rgbobj.1"
    end
    zsh_completion.install Dir["contrib/zsh_compl/_*"]
    bash_completion.install Dir["contrib/bash_compl/_*"]
  end

  test do
    # Based on https://github.com/rednex/rgbds/blob/HEAD/test/asm/assert-const.asm
    (testpath/"source.asm").write <<~EOS
      SECTION "rgbasm passing asserts", ROM0[0]
      Label:
        db 0
        assert @
    EOS
    system "#{bin}/rgbasm", "-o", "output.o", "source.asm"
    system "#{bin}/rgbobj", "-A", "-s", "data", "-p", "data", "output.o"
  end
end
