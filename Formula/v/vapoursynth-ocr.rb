class VapoursynthOcr < Formula
  desc "VapourSynth filters - Tesseract OCR filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vs-ocr/archive/R3.tar.gz"
  sha256 "e9da11b7f5f3e4acfee5890729769217aa5b385bb573cb303c2661d8d8a83712"
  license "MIT"
  version_scheme 1

  head "https://github.com/vapoursynth/vs-ocr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2c20c4ffb3ea7354b2cf70e66a713409b9b62cba6ddda5eb3e9b98af8b913359"
    sha256 cellar: :any,                 arm64_ventura:  "23f4b1b3d4db7e4147bb0814440dbfc7fd48caa629135d8438feceb05d79357d"
    sha256 cellar: :any,                 arm64_monterey: "972228660132a42823e45a5a2a6403f06a2db8ff240d7191b0eb692c93154143"
    sha256 cellar: :any,                 sonoma:         "35eae2559c4b298569ee7581a46a988d6d597143f00c227cc783757b9c1de40e"
    sha256 cellar: :any,                 ventura:        "96b4371b0a405577847782fba92187ce377ffc5d93037c1de836acd7aada60b6"
    sha256 cellar: :any,                 monterey:       "173146b8ced3df6b4b944474afffd9a7a4204af4425f7c197ecf035d2abc96e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80abfe935f66ee87e061ce9d1241bcde2a481280a8f4bd2b7fc249590e5b0b84"
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
