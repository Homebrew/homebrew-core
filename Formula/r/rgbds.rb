class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "ccba03909a9fd2067969134ef04c4165c1acffac5cd45899405214f9abd4157d"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "61f9327d50b1584d5b4b3809292b7724cfb7d82acb7a5c4d9c245f60403c61bc"
    sha256 cellar: :any,                 arm64_sonoma:  "56c1d55f4e3c04c940954e109746e636711f445fa971ef73e126a2f16713e627"
    sha256 cellar: :any,                 arm64_ventura: "95a36a5c8b9652693eb768ecce13f5456ac0aa1debe21f363b8bf6f520903fd6"
    sha256 cellar: :any,                 sonoma:        "765ef83e85524937bb0552c7e303312512fbd1b0a1dda9ce9683cc0d3818f6dd"
    sha256 cellar: :any,                 ventura:       "b0ac3c426aec5a5610f8c6e7736b36b99d6693d8bc413cd64e443130651feb02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5b2817a166380f0cf4b80b579a0eeb761f7dc6c011a3c5f47381158bdffdb44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fa0e0ee6496f99733f2ecf3b871716363c3b1ae79a248c9770ac218bd92dd59"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libpng"

  resource "rgbobj" do
    url "https://github.com/gbdev/rgbobj/archive/refs/tags/v0.5.0.tar.gz"
    sha256 "c05cf86445a4bcf8718389fbe6feeaa6091b9f500ddc746a589cdeb60c7c5519"
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
    assert_path_exists testpath/"test.2bpp"
  end
end
