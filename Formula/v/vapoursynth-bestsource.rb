class VapoursynthBestsource < Formula
  desc "Audio/video source and FFmpeg wrapper"
  homepage "https://github.com/vapoursynth/bestsource"
  url "https://github.com/vapoursynth/bestsource.git",
      tag:      "R16",
      revision: "cbdfd1e215d9a23323fb830c09e45e47b0864bc8"
  license "MIT"
  head "https://github.com/vapoursynth/bestsource.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9ca3b444c921c5cb9c383c7efcddc562669872abf3047280d57036bcc54988d9"
    sha256 cellar: :any, arm64_sequoia: "820aca62b50b4ed45c4668244d5eaa03c1df876b3d4853b2942947b8b511f89f"
    sha256 cellar: :any, arm64_sonoma:  "b34df6d230242324c384452f7d4fc1c71ce604a20aa6ee6cab08aeaf30725cbe"
    sha256 cellar: :any, sonoma:        "166c28a33592ec773f13d46030cec769ac2ced5cc372ce5194002d947e0cc605"
    sha256               arm64_linux:   "50012d8e87abc1aa472853fcf01620bd02ce042c1bfea9d3b16916d80343599a"
    sha256               x86_64_linux:  "c7ac63d3451f51b6ceb68436d2c074fa9591d3fd7c95cf5b2f3c5a9ddbfc0e9d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "vapoursynth"
  depends_on "xxhash"

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
              "install_dir = vapoursynth_dep.get_variable('libdir') / 'vapoursynth'",
              "install_dir = '#{lib}/vapoursynth'"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.bs"
  end
end
