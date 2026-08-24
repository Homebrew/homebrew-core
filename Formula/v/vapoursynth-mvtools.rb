class VapoursynthMvtools < Formula
  desc "Motion estimation and denoising filter for VapourSynth"
  homepage "https://github.com/dubhatervapoursynth/vapoursynth-mvtools"
  url "https://github.com/dubhatervapoursynth/vapoursynth-mvtools/archive/refs/tags/v29.tar.gz"
  sha256 "b1124604f76963e507c537839fd2ef1bee9b89b3c75bbd40c12a0c687aee6775"
  license "GPL-2.0-or-later"
  head "https://github.com/dubhatervapoursynth/vapoursynth-mvtools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6f51dd40f80a4b3de5a353b3536cf3b938aab0191a89661566a471e1f191b189"
    sha256 cellar: :any, arm64_sequoia: "f6dfd685bbce67d76cb7f6667b772bf7e08720595c455d14d2b51c7a60a597e6"
    sha256 cellar: :any, arm64_sonoma:  "4ba2f83033e2cc8ef5a475001c55d17a591795d18cdf4d2964ac1f170a5f868f"
    sha256 cellar: :any, sonoma:        "a928ba73bd115c65599f35e77e1b244df08be2b7300b82d0c928c836658af4d7"
    sha256               arm64_linux:   "c3c0373966a9f022eaf611a547b98ab3c7ed4c4226259f9a0c01db1eee43bea3"
    sha256               x86_64_linux:  "8e89537820532a7d393ad0700e0d7d7ab8be16a96db39c3b164d6a9ac75ca10f"
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
