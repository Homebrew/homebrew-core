class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "0eba653065d8ab6aaec9a4269bbd29efc2015189420154b2126ad410f1590e0e"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "539d2d88d9b4a79265fe76afa6327fbcdff2191a489108470e02f613678ec93a"
    sha256 cellar: :any,                 arm64_sonoma:  "1ce9f03abb52d9446dc61d26f6b286859dc8557a44f50fb71909df42f0d18048"
    sha256 cellar: :any,                 arm64_ventura: "d6bd1962a88e93ad490b427122beee788bdb65ed4bb565204f4ee285f2aaf866"
    sha256 cellar: :any,                 sonoma:        "5594f569e540143221c14d03b4ec75c36d5aef960c89cb974a7cacc6da2f215a"
    sha256 cellar: :any,                 ventura:       "21109da49cfc5bbdc1acde4f96baa080525f52587617a22d25398f072549c119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a242a2417d5852213ad72c3e873d6b7d3d24a38b9fb1e522ffadcb9ef7d9a785"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libpng"

  resource "rgbobj" do
    url "https://github.com/gbdev/rgbobj/archive/refs/tags/v0.4.0.tar.gz"
    sha256 "3871904f78d85ad6686df396d806950f9fc9ed612958c513fda3b962a8d63799"
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
    (testpath/"source.asm").write <<~ASM
      SECTION "rgbasm passing asserts", ROM0[0]
      Label:
        db 0
        assert @
    ASM
    system bin/"rgbasm", "-o", "output.o", "source.asm"
    system bin/"rgbobj", "-A", "-s", "data", "-p", "data", "output.o"
    system bin/"rgbgfx", test_fixtures("test.png"), "-o", testpath/"test.2bpp"
    assert_predicate testpath/"test.2bpp", :exist?
  end
end
