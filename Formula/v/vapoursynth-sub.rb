class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/subtext/archive/refs/tags/R5.tar.gz"
  sha256 "d1e4649c5417e671679753840ae0931cdbd353a862333129d7bd600770fd3db8"
  license "MIT"
  revision 1
  version_scheme 1
  head "https://github.com/vapoursynth/subtext.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "2a7e9a3f6ddb1982320e4319a9cea989f64f0631c077192f707ee341c88c03e7"
    sha256 cellar: :any,                 arm64_sonoma:   "a790bb27c1854e657d72731ea03ee7afc25b1400223a8603812ef8afad7a0554"
    sha256 cellar: :any,                 arm64_ventura:  "4eb095f03ea992f8c3fdb1140044a1146ff1cdbe8c9ff0b5805336fa4e4a94e9"
    sha256 cellar: :any,                 arm64_monterey: "a20a39d297e2fbee9881147990abcd0678e54e0aafa880126404fc67e5118bfe"
    sha256 cellar: :any,                 sonoma:         "395c38b3e3b818d6a80c0ea68b9045a13c9eddef5506176cb3586ce5d4859ffd"
    sha256 cellar: :any,                 ventura:        "ce5253289d282a21485141cf0e0fdf807121e83f340265e02e9e3631f18f679c"
    sha256 cellar: :any,                 monterey:       "a7445fbbfc200cc578a4d00ab7333989353fe0f2ccea4ed91f963ce97764828a"
    sha256                               arm64_linux:    "5bf6134027bc5e0e8d33a20e39c3145b761fae00bdd2829217bedd63e8c7388e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ebc9c1460d973e9f99019e07866d5422349101796a7a4267c83bc945bffceec"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libass"
  depends_on "vapoursynth"

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
              "install_dir : join_paths(vapoursynth_dep.get_pkgconfig_variable('libdir'), 'vapoursynth')",
              "install_dir : '#{lib}/vapoursynth'"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.sub"
  end
end
