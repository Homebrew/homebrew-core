class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/v0.5.1.tar.gz"
  sha256 "1e5331b5638076c1f099a961f8663256e9f8be21135427277eb0000d3d6ee887"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "67fbe0746e879838e5a9ad6999bec6f45889a650b29b2d97e3766630d6de2103"
    sha256 cellar: :any, big_sur:       "b202aecfdd3276b36c0dfff5434074753b19a298db6de61a0d6efefa341975fd"
    sha256 cellar: :any, catalina:      "94c1c67c1589868066218924f006f457436504cf49ebaaac36947d333b34cc3f"
    sha256 cellar: :any, mojave:        "0799a1f702a1333d592c97c093ba1096ce22766a60aca9870c5c6294e023b9a6"
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
