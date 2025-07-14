class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "e4db822494e438f4a3619a0043280fec5a16596ac1dc7756e7c8bf1c57ab0376"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "099374d50fc33525389c1f5c7cef08f89dc33c3ccbe70a226290d870c672f28f"
    sha256 cellar: :any,                 arm64_sonoma:  "8a29bb9c8bbe6279b6d1f74f029beecaf66c287ff9973f005baea074a3e7d72c"
    sha256 cellar: :any,                 arm64_ventura: "838be83ec89454dea3faa1ae7bc4e9807a551c62b0013ad2c00c7f1053557dc2"
    sha256 cellar: :any,                 sonoma:        "5d08e29a31d4f7ca93748363f8f24c8b99e365e6955471d077ab1e66b8f0fca0"
    sha256 cellar: :any,                 ventura:       "8a133e7f37c4ba78e3d83eb32f695c682a8ae425af262030601cba27889bee83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "834a5032dbfd7429862309e7f27b223cc8f94066d5e7eeacfb135604d247f1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "115f534747a1dac38feaba3699d487d24b082c62a6e579c1641731c2acf1f250"
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
