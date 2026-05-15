class Xcursorgen < Formula
  desc "Create an X cursor file from a collection of PNG images"
  homepage "https://gitlab.freedesktop.org/xorg/app/xcursorgen"
  url "https://gitlab.freedesktop.org/xorg/app/xcursorgen/-/archive/xcursorgen-1.0.9/xcursorgen-xcursorgen-1.0.9.tar.bz2"
  sha256 "a350f67323786aceef063e471d1661ae7e6d6ecb44e9143cf409070ad9ed053b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^xcursorgen[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5a0713ff32c930decc388076651fe5e73beb21aa505b03dd4b2728749663d7ea"
    sha256 cellar: :any, arm64_sequoia: "292615a8474ad7a790aca93e4bc63e0662ff7edb3ee20647b4883ac3172befa0"
    sha256 cellar: :any, arm64_sonoma:  "4ad2bc7648e4e570c2ef2a7bfec525fe471d750bc7ce9355aa20fe4145be6392"
    sha256 cellar: :any, sonoma:        "28f40fb83ea8cc38727e497929178411666e6148c76986b8d7fa6e699ad88918"
    sha256               arm64_linux:   "4084d49625b9907596de37f08c5b3d5aa4a013ea63a44673b478f9d2935b13fe"
    sha256               x86_64_linux:  "e86dc9a4b5c21398686ed6e8936617cd0f9bf78866a2f7b782cd84f977f206d8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxcursor"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cursor").write "8 2 4 test.png"
    testpath.install_symlink test_fixtures("test.png")
    system bin/"xcursorgen", "test.cursor", "test"
    bytes = (testpath/"test").binread(4).unpack("C*")
    assert_equal [0x58, 0x63, 0x75, 0x72], bytes
  end
end
