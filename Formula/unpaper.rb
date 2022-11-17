class Unpaper < Formula
  desc "Post-processing for scanned/photocopied books"
  homepage "https://www.flameeyes.com/projects/unpaper"
  url "https://www.flameeyes.com/files/unpaper-7.0.0.tar.xz"
  sha256 "2575fbbf26c22719d1cb882b59602c9900c7f747118ac130883f63419be46a80"
  license "GPL-2.0-or-later"
  head "https://github.com/unpaper/unpaper.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "94cb4a3ee882ef6f9ed1f1d08eb323f5152b910e4774d977207e4ecdd98982ae"
    sha256 cellar: :any,                 arm64_monterey: "3280a9ca24994ce8177a652bd6e6f8aef1b14689877b6f9d390cc298f760bcdd"
    sha256 cellar: :any,                 arm64_big_sur:  "0d18daf8c6731c254b00ba8a14ae88165fe6c517311c72eded94d1775127aa2e"
    sha256 cellar: :any,                 ventura:        "47cdec265ecc7ab97ad30d8e22ab49f708588975137f2d5a733860da5b1f69b0"
    sha256 cellar: :any,                 monterey:       "db689261f4f9c450f13cc531ea7e3554154cfc5ab0a1388f95cb9a59034f8444"
    sha256 cellar: :any,                 big_sur:        "8547a8225076be35086c103d79133a05f415b73938feeaf2af30a75a340bd76e"
    sha256 cellar: :any,                 catalina:       "84d445ef496a6e41803c598ace4f6649aabdb6e40a56e6db680cefdd9419617d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "784f4c2c287f116305b77a221dd7ca33fa205c919ca20e432bd8eae35f89da9f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "ffmpeg"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
