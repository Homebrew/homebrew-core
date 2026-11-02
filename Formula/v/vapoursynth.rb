class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://files.pythonhosted.org/packages/25/2e/1a5cb192ce26077c5afe9056a11b3a2d936c4e413b4fec5eee74d45bdb01/vapoursynth-82.tar.gz"
  sha256 "1128316620890ba8e5b69c924a665f98001b2ba4230dadead0f296446ea71843"
  license "LGPL-2.1-or-later"
  compatibility_version 2
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "fee835809ce89b8ff1cf486615d206ec93b0b2b91504517573d2618e4cdeb9d4"
    sha256               arm64_tahoe:       "6952c3a03ef5548f12e72588add3bf3818ba0d87c0ebf55c0223a88ef67c6139"
    sha256               arm64_sequoia:     "498f5462de067440786390f281c8be2470adc1957cf89ae25cd6692ec5201a3a"
    sha256 cellar: :any, arm64_linux:       "b9072b49c97a2eed0aee2279877414f321c3ed07d08dad2214fb338e52b9bcc3"
    sha256 cellar: :any, x86_64_linux:      "e8968416e2e813e265d15bdb6bb9b27c7eafe061e40cfdf310530644552b034e"
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
