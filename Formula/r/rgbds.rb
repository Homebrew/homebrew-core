class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "8608aa597bed638f37af6d1cc0752d5e1e02c549f28e3c887fb3e7326cc06351"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a16a3ea9decfdc52a4ca1d90dfb14b311ca61170c3c7af40f9d6d7581b804d70"
    sha256 cellar: :any, arm64_tahoe:       "8f0dcf9b69f106ad28c2b0b6e8fb047754923d23e54adf5a183dcd9ff739a674"
    sha256 cellar: :any, arm64_sequoia:     "61c018e5c904c7541904849bd315eb9c69a7efbcb1a9bdaeee868858a4a6e258"
    sha256 cellar: :any, arm64_linux:       "f4ca356a08d43636716cd63e545af105097c1445f617c6f53045a5ec0ff0d8e7"
    sha256 cellar: :any, x86_64_linux:      "d94507151784598b70aa56ba406b9c49d41195e77585190c5ccbb9d145906e2c"
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

  deny_network_access!

  def fetch
    resource("rgbobj").stage do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
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
