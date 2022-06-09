class Unpaper < Formula
  desc "Post-processing for scanned/photocopied books"
  homepage "https://www.flameeyes.com/projects/unpaper"
  url "https://www.flameeyes.com/files/unpaper-7.0.0.tar.xz"
  sha256 "2575fbbf26c22719d1cb882b59602c9900c7f747118ac130883f63419be46a80"
  license "GPL-2.0-or-later"
  head "https://github.com/unpaper/unpaper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "15a1aa7548aed02a7f8c82e541386b9122b2d74e628f0e123c3381c1690b11da"
    sha256 cellar: :any,                 arm64_big_sur:  "af3c1cb708fce8f19b3fd2b25a2aad65bfbb14513774be7cbbbc6eb6f755fb0b"
    sha256 cellar: :any,                 monterey:       "dffbdc83b6fb112d2bf8326ed93078749063a4796262a397fa7de93a46824056"
    sha256 cellar: :any,                 big_sur:        "96f88ae0ccb984448e56e48ad8cd2c1444e30beabcf375177bc2f064cc822a3e"
    sha256 cellar: :any,                 catalina:       "c9082fb7f7c6381df451dc2cdb14cece9f59605e563a70d811ffe9dae38c94c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8dfbd593ccaa3f878eea978943866a2791d66aa4ce15fdd183e6fea1a7be261"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "ffmpeg"

  on_linux do
    depends_on "gcc"
  end

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
