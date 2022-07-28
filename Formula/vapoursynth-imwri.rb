class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "https://github.com/vapoursynth/vs-imwri"
  url "https://github.com/vapoursynth/vs-imwri/archive/R2.tar.gz"
  sha256 "f4d2965d32877005d0709bd8339828f951885a0cb51e0c006d123ede0b74307b"
  license "LGPL-2.1-or-later"
  version_scheme 1
  head "https://github.com/vapoursynth/vs-imwri.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "ad45a8cee9ad643838d50cf96b81de7a4d9970e1440a1532a55e757068fd1448"
    sha256 cellar: :any, arm64_big_sur:  "26e4a9de02278ce275b3341cd95761421e713dddf9921c207c906e5c77a09711"
    sha256 cellar: :any, monterey:       "de583d45e9ddea5093874936f99a795ddc53a793ea98106df897abd88eda24b8"
    sha256 cellar: :any, big_sur:        "4cba2294a138c7518c11e2f98687aa681c9eca9848dc10921484f8f8eeb7d887"
    sha256 cellar: :any, catalina:       "3fff5e28b75d26a74370e6bfa78ab60112676440874d21530d51dfb0f4d8fb9c"
    sha256               x86_64_linux:   "ed81cf127676bd493d426d8381e3511ccee2bab3c7207420271533afe2bba087"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "imagemagick"
  depends_on "vapoursynth"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
              "install_dir = vapoursynth_dep.get_variable(pkgconfig: 'libdir') / 'vapoursynth'",
              "install_dir = '#{lib}/vapoursynth'"

    system "meson", *std_meson_args, "build"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_bin/"python3"
    system python, "-c", "from vapoursynth import core; core.imwri"
  end
end
