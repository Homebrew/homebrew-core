class VapoursynthOcr < Formula
  desc "VapourSynth filters - Tesseract OCR filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vs-ocr/archive/R2.tar.gz"
  sha256 "64ee82a6c9c59ab2aa0f5ab54224e42b027e39ea44be9784861d9e11c8532fb0"
  license "MIT"
  version_scheme 1

  head "https://github.com/vapoursynth/vs-ocr.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "9b635d6c1b56a97d6cdafef0470e26769486e19418400c56defdfa81d0577c9e"
    sha256 cellar: :any, arm64_monterey: "e8e11e248289747ce1cd57caed559dcd959c531a65b3151ff3bf04d638edc26b"
    sha256 cellar: :any, arm64_big_sur:  "20ad8e7a483b069cadc169f356006403b6ba10731b4f6f4bbd8848e4b9c72c63"
    sha256 cellar: :any, ventura:        "ed2c569fba05a3f3abd0b54f877326afa63bca120eefe0f3758c46fec20e96eb"
    sha256 cellar: :any, monterey:       "e2ccadae92be39e3f424c1b80629c4c80354b3ccf7228dd41575c71e04d1e1ca"
    sha256 cellar: :any, big_sur:        "26cc8b76d5f94632f73933cc9893f317f878c20e4e9156b3133e37df1c1c06ce"
    sha256               x86_64_linux:   "5da3243e4db078a215fc1cbacabc33538d2fc757a08812bc7839c76636785409"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "tesseract"
  depends_on "vapoursynth"

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
      "install_dir : join_paths(vapoursynth_dep.get_pkgconfig_variable('libdir'), 'vapoursynth')",
      "install_dir : '#{lib}/vapoursynth'"

    system "meson", *std_meson_args, "build"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.ocr"
  end
end
