class Unpaper < Formula
  desc "Post-processing for scanned/photocopied books"
  homepage "https://www.flameeyes.com/projects/unpaper"
  url "https://www.flameeyes.com/files/unpaper-7.0.0.tar.xz"
  sha256 "2575fbbf26c22719d1cb882b59602c9900c7f747118ac130883f63419be46a80"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/unpaper/unpaper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "03414c349a45717cc5c9269aaece72051676b4a9df0d6ace2adc48a141529e0b"
    sha256 cellar: :any,                 arm64_monterey: "472966ff01e3c2ded01d802e7ccb51ac067bfbd3936576fde97bc73d9a94e3d0"
    sha256 cellar: :any,                 arm64_big_sur:  "7cab5bdf86d2b767b01284ee82a012dac07b7e034c2728168a62c6dfa9926d00"
    sha256 cellar: :any,                 ventura:        "2131b439d88b39b3485030eb54bac1108ed19cad02d7995ee6ed4beb254f3e61"
    sha256 cellar: :any,                 monterey:       "5617fea75f70878d603fed75df6afbbd3abea7981c41cbe55065c08c2cd26437"
    sha256 cellar: :any,                 big_sur:        "69636bead34107d0247c5733b6b02b159f8434bf474a6b2c3279f8a8ad2ccd2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb3d2e57be1d69497e68cdc3a5fa7628d20dead74eab2c97f34a8d547b52ab68"
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
