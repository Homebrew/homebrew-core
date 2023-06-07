class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/v0.6.1.tar.gz"
  sha256 "fdc48f5b416fd200598320dec7ffd1207516842771a55a15e5cdd04a243b0d74"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1eec6c8d6d4f78f651b5532129e158284ce1173e1f12ac859deab109ebd0c039"
    sha256 cellar: :any,                 arm64_monterey: "cf443f1dab35c7793eb27897a3562988605c9d1e0fdbb9ead6c02c62eb4cda7d"
    sha256 cellar: :any,                 arm64_big_sur:  "86b0cb95d179d4a053bfbd8185edf64e3018a41fcb5707c3177ad3d0f9da4426"
    sha256 cellar: :any,                 ventura:        "df05b8cd3e6ca7b2830efac8b5795bcfa24857aac4912c3b6dd1437a60403a90"
    sha256 cellar: :any,                 monterey:       "33a3577cd38998588050aa6a615a1cbf0da29878623caacafa038f97660d98fb"
    sha256 cellar: :any,                 big_sur:        "2c96ef131dac0f73a8ebeff0cd7a30585496076bdca02dd5f0926940e5bab2f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a53081e67820c738c436eb06583ae338de9cf36d9c2e41c891c03beff017383"
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
