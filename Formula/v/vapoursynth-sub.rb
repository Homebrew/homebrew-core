class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/subtext/archive/R5.tar.gz"
  sha256 "d1e4649c5417e671679753840ae0931cdbd353a862333129d7bd600770fd3db8"
  license "MIT"
  version_scheme 1

  head "https://github.com/vapoursynth/subtext.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bb321921c838ae08e1d1483c9fc72b9858d7ffd370a8823318963e3846ed407b"
    sha256 cellar: :any,                 arm64_ventura:  "0258a3b9f674fb743f80df4eedc3f9fea6f8e00b45e620c1127e4b15fc030926"
    sha256 cellar: :any,                 arm64_monterey: "f0adbc546c139b96804bfb083d63cf42005f2db0b2ed1afa0dbc23eff45252cc"
    sha256 cellar: :any,                 sonoma:         "94b50882d7928c58e7b3aa2519f3f8d2da87e197e370e712336dd79a71f34585"
    sha256 cellar: :any,                 ventura:        "afdf0b9a0d66d1da21e20acc32eddc456ec6bc5ddbe029c6b96c8ed364def826"
    sha256 cellar: :any,                 monterey:       "69c95c61af3cf9821dfdda41b428b64ac14682f0dffb1dbd8ab3d156dacb17a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aad0ea9472b15f08dc37d1bf79e6cfe2dc9531b9b56c26c74b49595ba5ce4b5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libass"
  depends_on "vapoursynth"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    # A meson-based install method has been added but is not present
    # in this release. Switch to it in the next release to avoid
    # manually installing the shared library.
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    (lib/"vapoursynth").install "build/#{shared_library("libsubtext")}"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.sub"
  end
end
