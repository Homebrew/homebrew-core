class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "2be649a6b3c3b4a462e222b3082fa2e1c83142f317ba862b17899f5a25717380"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f87dfc01d98b7680f8649848bb7ce740f65d40a2fe29d13bf19e797d68017263"
    sha256 cellar: :any,                 arm64_sonoma:  "4dd20f6948588fbf2014fd1ac758c3e9b58ffe959fc55a436f1a3e5d0c88ea8f"
    sha256 cellar: :any,                 arm64_ventura: "bbb63d0c35cd30abdf979ada4bbacd9e7af240cd4d95f791d26f0baef17f5c21"
    sha256 cellar: :any,                 sonoma:        "12e3c9959a097c87290512e26fc609d5e26fe99a89658cb20561f94102953661"
    sha256 cellar: :any,                 ventura:       "9194b4cacf21ff1ea05970d7e3861f21eb4f6f78b4c2ebdd17eaaf949d6d2ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8d11ec5b3e1c034bfda24f02aeafca94dab736b403381b9e41628a9c25be21a"
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
