class Unpaper < Formula
  desc "Post-processing for scanned/photocopied books"
  homepage "https://www.flameeyes.com/projects/unpaper"
  url "https://www.flameeyes.com/files/unpaper-7.0.0.tar.xz"
  sha256 "2575fbbf26c22719d1cb882b59602c9900c7f747118ac130883f63419be46a80"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/unpaper/unpaper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "13a3d8a2709a9ff5af9d0cfe4149ecfed559ab159e89157d090363226a94149b"
    sha256 cellar: :any,                 arm64_ventura:  "bbce025f0f3d27f9980e1032a83434024d6dca13fb547c4360c481cda4c43d65"
    sha256 cellar: :any,                 arm64_monterey: "10c463411cad146cee0c513868d177e9a5ec6d1fdea8f9cb2ad466f08715ac48"
    sha256 cellar: :any,                 sonoma:         "1de18988f8f9373530a98bcdc7390dc87817e828b109171a284f60ac70c524e7"
    sha256 cellar: :any,                 ventura:        "9f4cc2bc495825b3b08e4103dda38e194dded68c4a3f122182d408b43a5b0bda"
    sha256 cellar: :any,                 monterey:       "4ea845e807a1a65a35b1e7d56dab12ee3778d18446770b6afc6f708d858e8dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae26a1afe4806f2903bbfce2d359c7485b75bdf1bc04e25674fd0cf3b283605f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "ffmpeg"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.pbm").write <<~EOS
      P1
      6 10
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      1 0 0 0 1 0
      0 1 1 1 0 0
      0 0 0 0 0 0
      0 0 0 0 0 0
    EOS
    system bin/"unpaper", testpath/"test.pbm", testpath/"out.pbm"
    assert_predicate testpath/"out.pbm", :exist?
  end
end
