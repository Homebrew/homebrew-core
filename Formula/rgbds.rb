class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/v0.5.1.tar.gz"
  sha256 "1e5331b5638076c1f099a961f8663256e9f8be21135427277eb0000d3d6ee887"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c58fe406517c99fec5089d8cd0017ee86d3cefcadf3bbbbe5bbfabc9afced515"
    sha256 cellar: :any,                 arm64_big_sur:  "44cca5083d32dfa42a6d7d120079eabff0c375ff432851de28a61a943725ceb8"
    sha256 cellar: :any,                 monterey:       "ae748c48314780fdde9870076ae2ae4c8915c8293924a7aa48bad68f32dbe519"
    sha256 cellar: :any,                 big_sur:        "3f02c082066bc835f042a37ae3e972cb58a77a615634f299e33f301dab46b6c1"
    sha256 cellar: :any,                 catalina:       "9927685009fa383bc393eb32e36cb44d1db0cce12f06640b323f44d6589ad50c"
    sha256 cellar: :any,                 mojave:         "e778e85fdb6ea1b00d1d25648e6da9fbfe92c35779dd6be1ae62abc8eb459077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21221704428b141cc9ea34e5d69598791620a22a68022d98b39d4d78bbbbfa4d"
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
