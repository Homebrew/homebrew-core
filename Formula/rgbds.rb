class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/v0.6.0.tar.gz"
  sha256 "dcf26588b52a8ccfa28aa47c14f6b222f096f1109c658b3fe57dd6ff150cd0ab"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8825196bc19415872f2b9b65bf3ce7e91ec8d1bddb43c74e40838cd273c79421"
    sha256 cellar: :any,                 arm64_big_sur:  "32163f2fc3313e80a91136a980a996c48b15d2dfa9aa3767ab9fedd8ea26f0f3"
    sha256 cellar: :any,                 monterey:       "ae055f9546c5ccc0ff4f05cc02ef28a79802293baaf8d404171783449d8cf82f"
    sha256 cellar: :any,                 big_sur:        "bb2749706783eecf9af80b6fe1cd89594e09f2fb7f2463a143f5371303db33a2"
    sha256 cellar: :any,                 catalina:       "1c0ada26f7e4065187a09ea2dfdf647dba64aa11460cd37c8882f0e883144083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3edaa68d9e948100b36d8347d3ddade81f84f302f15ba81b22016671441fbe11"
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
