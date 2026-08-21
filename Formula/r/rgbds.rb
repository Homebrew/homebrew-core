class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "e79e51bdc0e53d8b52b5b9b58a5cbe15d6a380092da67dd625aeca29f6679660"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "93f31d34c69552e6d490335e18de854608534d0c0eb63e267a33f35eb3017015"
    sha256 cellar: :any, arm64_sequoia: "006fb511cf3db6207326617600434daafcf0b090bba5d38b77696135c8991b33"
    sha256 cellar: :any, arm64_sonoma:  "1db73630c13c6f99ac6ddeadecec65a95ec05b30a4d98694ff7723819ff0f62e"
    sha256 cellar: :any, sonoma:        "8b4ea62968b4e34822e2bacbf6043b9bcbb23fcf6a3739e5868b913ab2e7c34b"
    sha256 cellar: :any, arm64_linux:   "5a2e8a0bd0ea76f9766a079103f10d9b36f47766750a14b64690df67883f4f11"
    sha256 cellar: :any, x86_64_linux:  "5487484080210eb64058c40f4747bc9a3e0b09034e8a4dd04b48062e45e5c0b8"
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
