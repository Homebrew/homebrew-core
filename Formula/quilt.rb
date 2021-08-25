class Quilt < Formula
  desc "Work with series of patches"
  homepage "https://savannah.nongnu.org/projects/quilt"
  url "https://download.savannah.gnu.org/releases/quilt/quilt-0.66.tar.gz"
  sha256 "314b319a6feb13bf9d0f9ffa7ce6683b06919e734a41275087ea457cc9dc6e07"
  license "GPL-2.0"
  head "https://git.savannah.gnu.org/git/quilt.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/quilt/"
    regex(/href=.*?quilt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fdf0ee99668648eee4cf197c0d0107984330bfa07e6effef28ea7586f40716e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "fedbbbff60a547d82005736175e9264ea217aff6821e40eda9ccf9b77e1f07e0"
    sha256 cellar: :any_skip_relocation, catalina:      "b7304ce0125f31f6d38f8645d436de553f765b599e4c66f8f659478963bf33f6"
    sha256 cellar: :any_skip_relocation, mojave:        "5d7f412108ec8831b8b6bfbc8e41d8b577523ffd66f9d095853a4680ec23b04f"
    sha256 cellar: :any_skip_relocation, high_sierra:   "691a01a091194910f0848aea529b331559fb98d44e9821c1ebafba51d2a2d62c"
    sha256 cellar: :any_skip_relocation, sierra:        "2305addd5b8f4b256701b2ec89ec9caffa4699dae48e63f8cac0478545b5d860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b672985441c4f512f4572fc240818504ea91bca96b67f1fcb2e88dbd4c8b0d1"
  end

  depends_on "coreutils"
  depends_on "gnu-sed"

  def install
    args = [
      "--prefix=#{prefix}",
      "--without-getopt",
    ]
    on_macos do
      args << "--with-sed=#{HOMEBREW_PREFIX}/bin/gsed"
    end
    on_linux do
      args << "--with-sed=#{HOMEBREW_PREFIX}/bin/sed"
    end
    system "./configure", *args

    system "make"
    system "make", "install", "emacsdir=#{elisp}"
  end

  test do
    (testpath/"patches").mkpath
    (testpath/"test.txt").write "Hello, World!"
    system bin/"quilt", "new", "test.patch"
    system bin/"quilt", "add", "test.txt"
    rm "test.txt"
    (testpath/"test.txt").write "Hi!"
    system bin/"quilt", "refresh"
    assert_match(/-Hello, World!/, File.read("patches/test.patch"))
    assert_match(/\+Hi!/, File.read("patches/test.patch"))
  end
end
