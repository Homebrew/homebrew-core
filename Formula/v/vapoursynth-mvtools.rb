class VapoursynthMvtools < Formula
  desc "Motion estimation and denoising filter for VapourSynth"
  homepage "https://github.com/dubhatervapoursynth/vapoursynth-mvtools"
  url "https://github.com/dubhatervapoursynth/vapoursynth-mvtools/archive/refs/tags/v28.tar.gz"
  sha256 "48d59695f953ba51dc31911b062417f6ee8f88bbae21a76ff92a4918800ce092"
  license "GPL-2.0-or-later"
  head "https://github.com/dubhatervapoursynth/vapoursynth-mvtools.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "60a91ba370a973bdd5c198961bbd14959e2db8696425e8189bc7ee1a5d5b5f0f"
    sha256 cellar: :any, arm64_sequoia: "87a1487148729700475da6595c6d763e452005be8873da15e57e8ebd9f4d28a6"
    sha256 cellar: :any, arm64_sonoma:  "4221cb2a27e8c22d1594961ca1b2cd5b83bd9eae5416abc66cb1a165e363c57a"
    sha256 cellar: :any, sonoma:        "a037eb44f6f6b832df02e8e666bd6317cef3067ed642b1d52a50dcdcb6ab1766"
    sha256               arm64_linux:   "41a694a7adb6f5b7a7d723f7aed9b469f26a3b3abdeb08b05ca00f494b81e423"
    sha256               x86_64_linux:  "5c817c8e05887e9061277da94d9a295928b088df0ac363c7ed59c1db375b655c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "fftw"
  depends_on "python@3.14"
  depends_on "vapoursynth"

  on_intel do
    depends_on "nasm" => :build
  end

  def python3 = "python3.14"

  def install
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    # Work around Homebrew's python prefix patch
    args = %W[-Dpython.platlibdir=#{prefix/Language::Python.site_packages(python3)}]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    script = <<~PYTHON.split("\n").join(";")
      import vapoursynth as vs
      vs.core.mv.Super(vs.core.std.BlankClip(format=vs.GRAY8))
    PYTHON
    system python3, "-c", script
  end
end
