class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  license "LGPL-2.1-or-later"
  compatibility_version 2
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  stable do
    url "https://github.com/vapoursynth/vapoursynth/archive/refs/tags/R76.tar.gz"
    sha256 "8c51aedc26a5fa2b79b5716bfe1160ffa45c69035c728b7e8740785cf790454b"

    # Backport commit to avoid statically linking dependencies' libraries
    patch do
      url "https://github.com/vapoursynth/vapoursynth/commit/d398f465154ef141d447af78b2e65a025de28522.patch?full_index=1"
      sha256 "3d19b95ed0ba5de76e450ed0dedf7ab7935c0de1e0d08affc3be914c6aefa511"
    end
  end

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f41497f7d9125d46e2a1107703c7ad0b50c525bfe35e91852ae662924bde8530"
    sha256 cellar: :any,                 arm64_sequoia: "63c23ce0bba6205dc776841f3cd04a32eac7ea5c50c43f750fc95b041536ec57"
    sha256 cellar: :any,                 arm64_sonoma:  "c560b8e6c2ac6c98311d70d503fea75992c63b77ed1acf873f2a5116c58a0a1f"
    sha256 cellar: :any,                 sonoma:        "e8f82e6847aa3269a7ca164deb18e2b716a5542b683a63ae9f74c7ac52f39986"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "381d6e92a08cccc4ea948ecc5a17b1dd462a16914856e1db6a8d59ffee7b150f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fccb9b37413710801eaaab943b634c008026748584a50c327362b2810498c13"
  end

  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
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

  def python3 = "python3.14"

  def install
    ENV.runtime_cpu_detection if Hardware::CPU.intel?
    ENV.prepend "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/c++" if OS.mac? && MacOS.version <= :ventura

    # NOTE: Cannot `pip install` into prefix as VapourSynth expects a standard
    # installation and won't work with Homebrew's symlink directory structure.
    venv = virtualenv_install_with_resources
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
