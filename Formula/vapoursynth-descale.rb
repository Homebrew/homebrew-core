class VapoursynthDescale < Formula
  desc "VapourSynth plugin to undo upscaling"
  homepage "https://github.com/Irrational-Encoding-Wizardry/vapoursynth-descale"
  url "https://github.com/Irrational-Encoding-Wizardry/vapoursynth-descale/archive/refs/tags/r6.tar.gz"
  sha256 "af68c424c146f429e72401e5095f78b57c6a9324a1d19600a9cf0fa85c6bf9c3"
  license "WTFPL"
  head "https://github.com/Irrational-Encoding-Wizardry/vapoursynth-descale.git"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vapoursynth"

  def install
    inreplace "meson.build", "install_dir: installdir", ""
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    site_packages = "lib/python#{xy}/site-packages"
    (prefix/site_packages).install "descale.py"
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/vapoursynth").mkpath
    (HOMEBREW_PREFIX/"lib/vapoursynth").install_symlink prefix/"lib/libdescale.dylib" => "libdescale.dylib"
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "from vapoursynth import core; core.descale"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "from descale import Descale; Descale"
  end
end
