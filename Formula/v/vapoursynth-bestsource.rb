class VapoursynthBestsource < Formula
  desc "Audio/video source and FFmpeg wrapper"
  homepage "https://github.com/vapoursynth/bestsource"
  url "https://github.com/vapoursynth/bestsource.git",
      tag:      "R17",
      revision: "b026135190bdee175417310fa783e8383077193f"
  license "MIT"
  head "https://github.com/vapoursynth/bestsource.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "903837f14e16c322a2a9639513d84e56b742fc354ae8787a7994ad29270d5b5c"
    sha256 cellar: :any, arm64_sequoia: "ebdb1525c806298ec8db8dba220241d933637ea0264c60c5e461c0e7cd863690"
    sha256 cellar: :any, arm64_sonoma:  "537d55ec45b572a34bfe8fb80e211a90db4453d90aa30682329717c4a8c9f42e"
    sha256 cellar: :any, sonoma:        "e0c31585f38454ca70ee5822956f1ea71b3d40d1e8e6aa971d182e141de0ff4a"
    sha256               arm64_linux:   "12acaacf82013204b896550646ed348ce33b21c342f2ff85d241e8e6e4bb7ed3"
    sha256               x86_64_linux:  "3626373742df1edbaacc8a8f379a8070bd8984dd7597e917a2690b4b27f40843"
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
    inreplace "meson.build" do |s|
      s.gsub!("py.get_install_dir() / 'vapoursynth/plugins'", "get_option('libdir') / 'vapoursynth'")
      s.gsub!("-march=x86-64-v2", "-msse4.1")
    end

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
