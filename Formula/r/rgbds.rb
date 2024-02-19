class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "ef04d24d7a79c05ffadac0c08214f59b8d8812c7d1052a585e5ab0145f093b30"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c1c0bda09f9b4d3ff0eb38ba528aed01a4bb36c3df45d36409778f35852dda49"
    sha256 cellar: :any,                 arm64_ventura:  "ac809ea02ad3b8f89ab89116c0e4138993b069a8e82d7512ac2dfb520506178b"
    sha256 cellar: :any,                 arm64_monterey: "3ff99f46c769f04633aed867465af73f22321d5395c99c4f98fb3460af66f9c2"
    sha256 cellar: :any,                 sonoma:         "6dfc174514bf7b613b7b4c678d99c7daf965f03e681870f89b7abca3334842cb"
    sha256 cellar: :any,                 ventura:        "a0daa592ca2112053a0ca2b34437a10c1492a1a7127c17f22ef454f16fce82e7"
    sha256 cellar: :any,                 monterey:       "db2a8ecb7d5c1bf55489604210bcd028b6b8fab8a9aeb711ec15f2f0d0cf6cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5081091e37107f494dfa92b07d804b24df19e2d42e70eea68f6788a8ff39cfa"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpng"

  resource "rgbobj" do
    url "https://github.com/gbdev/rgbobj/archive/refs/tags/v0.2.1.tar.gz"
    sha256 "3d91fb91c79974700e8b0379dcf5c92334f44928ed2fde88df281f46e3f6d7d1"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
    system bin/"rgbasm", "-o", "output.o", "source.asm"
    system bin/"rgbobj", "-A", "-s", "data", "-p", "data", "output.o"
    system bin/"rgbgfx", test_fixtures("test.png"), "-o", testpath/"test.2bpp"
    assert_predicate testpath/"test.2bpp", :exist?
  end
end
