class VapoursynthMvtools < Formula
  desc "Motion estimation and denoising filter for VapourSynth"
  homepage "https://github.com/dubhatervapoursynth/vapoursynth-mvtools"
  url "https://github.com/dubhatervapoursynth/vapoursynth-mvtools/archive/refs/tags/v29.tar.gz"
  sha256 "b1124604f76963e507c537839fd2ef1bee9b89b3c75bbd40c12a0c687aee6775"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/dubhatervapoursynth/vapoursynth-mvtools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e630e9616c3ec7785bce37a3506bd4508b18f7c7dca29e165b4a545770b1ebf0"
    sha256 cellar: :any, arm64_tahoe:       "5cbd3626405d4020e28cf25af2c9a93e2827bda6ce681ae9b5ea4df14371057d"
    sha256 cellar: :any, arm64_sequoia:     "40e7f01cfff91b6f592c4bbcdbd87ba8f9f1846cc62ad02940ca351b6a114be4"
    sha256 cellar: :any, arm64_linux:       "66016f9a69063f07b349348e20993c44550bdb6b6a967b7427d2fabc6edc9c7b"
    sha256 cellar: :any, x86_64_linux:      "3dfdfe71eaa956d719dce300a78a2111f8cd71fd63d947e40e6b641cfabab465"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "fftw"
  depends_on "python@3.15"
  depends_on "vapoursynth"

  on_intel do
    depends_on "nasm" => :build
  end

  # Fix compilation on Linux
  patch do
    url "https://github.com/dubhatervapoursynth/vapoursynth-mvtools/commit/895bf5d145cf8d2f3633ebc3aba0e32fe4cd5a7d.patch?full_index=1"
    sha256 "412d1d727d3c706a044c2f6cb0ec006114f69e89c6c81503d4fca0131a9c18a6"
    type :unofficial
    resolves "https://github.com/dubhatervapoursynth/vapoursynth-mvtools/pull/104"
  end

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
