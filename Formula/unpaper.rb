class Unpaper < Formula
  desc "Post-processing for scanned/photocopied books"
  homepage "https://www.flameeyes.com/projects/unpaper"
  url "https://www.flameeyes.com/files/unpaper-7.0.0.tar.xz"
  sha256 "2575fbbf26c22719d1cb882b59602c9900c7f747118ac130883f63419be46a80"
  license "GPL-2.0-or-later"
  head "https://github.com/unpaper/unpaper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "74997b9a9738930333b8c4cb000a055d2bc9dd42510be3e9d6d2f96a80908eba"
    sha256 cellar: :any,                 arm64_big_sur:  "d0b6c4e384cc73092163b88989eed3a87a5d489e693ecafcebfa5770f4e3d6d3"
    sha256 cellar: :any,                 monterey:       "1dad125fcaf9aa24d1b347a575d286dbad91c7e5e475813314f3084ee1dd3947"
    sha256 cellar: :any,                 big_sur:        "3e23cbc93bf46fce64ebd7277e23207090c1275b067294f360d3437778cf9c03"
    sha256 cellar: :any,                 catalina:       "58134afe9017002e684e0ff392e77ee1eca707fa8e323ee7283858054be811eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abeb5bcc20a8037dd4629cb662d1eaf71ebcf901474e508b13e911d65dce1317"
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
