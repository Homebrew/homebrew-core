class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e2cc698faab1526770e4080763efd95713f20a8459977ba0bc402d2c2f986c5e"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "932807ce8cafe868439e1e0191dd3f578f637a404a772046c888f14a778d389f"
    sha256 cellar: :any,                 arm64_sequoia: "0d294dca021c83b86a8d64ba863b2dff314b584a2b3175afe1d055e560c9d49b"
    sha256 cellar: :any,                 arm64_sonoma:  "84b5bd7baf7c9e1366468a2d072f67e00718d7fc5b8c3ae7cdeb3691535dd81f"
    sha256 cellar: :any,                 sonoma:        "50976526eb7e75a1365b2218eb7262b4280c056b2c6b4cc4bb9c257ee861910f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a80312f79d9c3020079d1f1cadd81be1c1f2e67a4c368a7e6832f94cf7ca1498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d176a4f6cb13352755f441453c19c3fae5ab1b46b46090d12b9be9a907871a0f"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libpng"

  resource "rgbobj" do
    url "https://github.com/gbdev/rgbobj/archive/refs/tags/v1.0.0.tar.gz"
    sha256 "9078bfff174b112efa55fa628cbbddaa2aea740f6b2f75a1debe2f35534f424e"
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
    # Based on https://github.com/gbdev/rgbds/blob/HEAD/test/asm/assert-const.asm
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
