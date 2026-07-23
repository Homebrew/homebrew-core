class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/refs/tags/v1.0.2+hotfix.tar.gz"
  sha256 "e58d5b74a371f7c2aee9dbe621b44c5fa5f49cda85a44fd974efd8ee059a057b"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4b26edc3fc5cec97f4f3e9de54fbfdfdd62e3feca14fcf7d000a13adecedc2a7"
    sha256 cellar: :any, arm64_sequoia: "15998e957064bcdf3532424ebc5adb09ee0d354fb75d369c7eb55a6ed74b8e82"
    sha256 cellar: :any, arm64_sonoma:  "d7ae5850aec1f249b29b6c48bc94e7de84590f41e3d8d8a3f2bb8c8f25120bc4"
    sha256 cellar: :any, sonoma:        "1fa5e9a8d3b3c7c3eb744f1a850edb0f7a2ee7a04e754af189c65391a46a931e"
    sha256 cellar: :any, arm64_linux:   "bc2512ae4cc608969f2f44704a62cea7cdf6db5db431da1ed17a5a9c58553e0d"
    sha256 cellar: :any, x86_64_linux:  "6daa7a1e652c9a2e61f6fd61caf018e10df5ac768f370c763c1849955a66c235"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libpng"

  on_linux do
    depends_on "zlib-ng-compat" => :build
  end

  resource "rgbobj" do
    url "https://github.com/gbdev/rgbobj/archive/refs/tags/v1.0.0.tar.gz"
    sha256 "9078bfff174b112efa55fa628cbbddaa2aea740f6b2f75a1debe2f35534f424e"
  end

  def install
    args = %w[
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
