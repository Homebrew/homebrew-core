class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://files.pythonhosted.org/packages/69/6a/f9441173c91a3355a32b870522726ed2252cd3c7b04b45e499f30b1a2c98/vapoursynth-81.tar.gz"
  sha256 "3bf6c90ad737e8ffc5605b05a1ff29cd884f8632fbe0eb49a2705942073a96be"
  license "LGPL-2.1-or-later"
  revision 1
  compatibility_version 2
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "7cc5660b28f3e9944ac92989a9c6d4c0275971ae9ef1de3bad813693b3e3e80b"
    sha256               arm64_tahoe:       "f59763b802efe4273b3374df2facc13dffc2a4d04ccece5cd436d720ec9574f5"
    sha256               arm64_sequoia:     "f278d9fa49033b1f90692ad4a92ffc4d903b8fc1cb61e85f9d6b6edbe565394b"
    sha256 cellar: :any, arm64_linux:       "646cbade5992aa323a97ac9c51d357374314446559493e93aff18795e237ecc4"
    sha256 cellar: :any, x86_64_linux:      "a910474cc3fdf6ca185abe0d3a1f30313b7ed6cbae128d7b9803f5a2d30ebcc1"
  end

  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vulkan-headers" => :build
  depends_on "python@3.15"
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
    url "https://github.com/KhronosGroup/glslang/archive/refs/tags/vulkan-sdk-1.4.363.0.tar.gz"
    sha256 "cda24ec765e6d2845d106b7caa593f34127195a88524cf87821ff0088fb6edec"

    livecheck do
      url :url
      regex(/^vulkan-sdk-(\d+(?:\.\d+)+)$/i)
    end
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
