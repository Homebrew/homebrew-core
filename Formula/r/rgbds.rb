class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "193469d38229a653bb33a25ebb73fd0ae33da4be80191d83bce8d427d23b7704"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fedb922933f87988dedef927823d41d3426509ab9b203baab00747ec86bb227e"
    sha256 cellar: :any,                 arm64_sequoia: "b7da5ca6fb3eb3d3a9016e9089a7e6ee8f05b59717503faddb49e8b4ea76bbc6"
    sha256 cellar: :any,                 arm64_sonoma:  "ee01628a3b4b7e3af26905957aa60d41bff57e45ada79ca1ea43f80587534f19"
    sha256 cellar: :any,                 sonoma:        "4b787f2390864c7d1fe0aff76137fd0ee77e74320100925813b81a672c988561"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dacc9e6e1a2791f7dbfcea1e34a6bd178b767664d21b225527247044e9b401c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a835c2383da7339dbd7d22dd817484207a7a04e0e26fd664c7068cfcb5dd0de6"
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
