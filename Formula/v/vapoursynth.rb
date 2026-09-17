class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://files.pythonhosted.org/packages/66/22/4e7bb7682495b03470b2f594cbe30b13fb81d7b3378edf359042c9f1f6bf/vapoursynth-80.tar.gz"
  sha256 "4d03e3ef64df65a855490e6fd77ccc74d5debf89799aea93a6bd08f6a90afeb0"
  license "LGPL-2.1-or-later"
  compatibility_version 2
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "916c19c0f178f4ea6e7058eb1335bf8c6e61d9484afc5ab521fed12ee20a74dd"
    sha256 cellar: :any, arm64_tahoe:       "c5ff77b3f31024cfbfe24773cf1631ef219cc4de0b359bde85a44a8b882d6bf4"
    sha256 cellar: :any, arm64_sequoia:     "e20dd4d4f2548c9a5cd4eefdde4625a71b454e465b209165e5c2581d560bec1b"
    sha256 cellar: :any, arm64_sonoma:      "f65efd43ac1003437bcd5867249b21985d61dbf1aec80c968a730d54e1aa2e17"
    sha256 cellar: :any, sonoma:            "56d36a07465ace8bfbd6e31d142b4982fa4d072b7b6c01553100d8f34b7252e0"
    sha256 cellar: :any, arm64_linux:       "93540be19ad3da0bcb075e8a4a531160e8c6f10f9032393d85eba4e826a77d96"
    sha256 cellar: :any, x86_64_linux:      "a1e856c46192c84396bcd5d403f1b954323d20f30e77627af0af95b67a0289f5"
  end

  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vulkan-headers" => :build
  depends_on "python@3.14"
  depends_on "zimg"

  # std::to_chars requires at least MACOSX_DEPLOYMENT_TARGET=13.3
  # so it is possible to avoid LLVM dependency on Ventura but the
  # bottle would have issues if system was on macOS 13.2 or older.
  on_ventura :or_older do
    depends_on "llvm"
    fails_with :clang
  end

  on_linux do
    depends_on "patchelf" => :build
  end

  # Upstream pins the shader compiler to keep the accepted GLSL dialect stable.
  resource "glslang" do
    url "https://github.com/KhronosGroup/glslang/archive/refs/tags/vulkan-sdk-1.4.357.0.tar.gz"
    sha256 "81038794e20494556edbcc0fc70fa984d71d1b440f9c49adf2cbaaa60a519757"
  end

  def install
    ENV.runtime_cpu_detection
    ENV.prepend "LDFLAGS", "-L#{formula_opt_lib("llvm")}/c++" if OS.mac? && MacOS.version <= :ventura

    resource("glslang").stage("subprojects/glslang")
    cp_r Dir["subprojects/packagefiles/glslang/*"], "subprojects/glslang"

    # NOTE: Cannot `pip install` into prefix as VapourSynth expects a standard
    # installation and won't work with Homebrew's symlink directory structure.
    venv = virtualenv_install_with_resources(without: "glslang")
    (prefix/Language::Python.site_packages(python3)/"homebrew-vapoursynth.pth").write venv.site_packages

    # Automatically load plugins installed in separate formulae
    vapoursynth = venv.site_packages/"vapoursynth"
    vapoursynth.install_symlink HOMEBREW_PREFIX/Language::Python.site_packages(python3)/"vapoursynth/plugins"

    # Add compatibility symlinks to help dependents find VapourSynth
    (lib/"pkgconfig").install_symlink vapoursynth/"pkgconfig/vapoursynth.pc" # needed by mpv.pc
  end

  def caveats
    <<~EOS
      This formula does not contain optional filters that require extra dependencies.
      To use vapoursynth.core.bs, execute:
        brew install vapoursynth-bestsource
      To use vapoursynth.core.ocr, execute:
        brew install vapoursynth-ocr
      To use vapoursynth.core.sub, execute:
        brew install vapoursynth-sub
      To use vapoursynth.core.ffms2, execute:
        brew install ffms2
      For more information regarding plugins, please visit:
        https://www.vapoursynth.com/doc/installation.html#plugins-and-scripts
    EOS
  end

  test do
    system python3, "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end
