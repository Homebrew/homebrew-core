class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/subtext/archive/refs/tags/R5.tar.gz"
  sha256 "d1e4649c5417e671679753840ae0931cdbd353a862333129d7bd600770fd3db8"
  license "MIT"
  revision 2
  version_scheme 1
  head "https://github.com/vapoursynth/subtext.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "66be173efb94e72979fb21fd34617d7dbfe31fc1a59a91fd327264303753c0d7"
    sha256 cellar: :any, arm64_sequoia: "4c5a5ece07feae55fe604f485bf45c3005565a2479ce6cb318f0732bddd529ff"
    sha256 cellar: :any, arm64_sonoma:  "73845ff92fa1677f86fbbccf84d5e2cd461078f650fe1372edefa4f9e7538b41"
    sha256 cellar: :any, arm64_ventura: "8d5b3e8589adfc64e774b1b9f717406c56b552aea8f4cdd8ac97750411492e91"
    sha256 cellar: :any, sonoma:        "c4fa3e6025b1835664760fa97c5971cf31179cddae818de5d18e03655e04bcfc"
    sha256 cellar: :any, ventura:       "047cfdebb5cf5bee06d1238db056ab7a70896b040bb25c7ffffe0d94f025504a"
    sha256               arm64_linux:   "2bbe3501f1c999b11558063e691155ead7aaa80b6e68ee9f69e0ec992b3835e4"
    sha256               x86_64_linux:  "20aa5b0a19e74a404e14a24328ff7de1e07101682c44063d57677d50d7b3007e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libass"
  depends_on "vapoursynth"

  # Apply open PR to support FFmpeg 8
  # PR ref: https://github.com/vapoursynth/subtext/pull/17
  patch do
    url "https://github.com/vapoursynth/subtext/commit/09c9e2bb87a635cdc5377c70983f8ceb7fae5841.patch?full_index=1"
    sha256 "362498e7e97d5039dcf6bed4b146e6f3995dda321ceb4c78545e44dbe5062255"
  end

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
