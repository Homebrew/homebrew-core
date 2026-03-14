class VapoursynthMvtools < Formula
  desc "Motion compensation and stuff"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://github.com/dubhater/vapoursynth-mvtools/archive/refs/tags/v24.tar.gz"
  sha256 "ccff47f4ea25aa13b13fabd5cf38dd0be1ceda10d9ad6b52bd42ecf9d6eb24ad"
  license "gpl-2.0-only"
  head "https://github.com/dubhater/vapoursynth-mvtools.git", branch: "master"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "vapoursynth"

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    mkdir "#{lib}/vapoursynth"
    ln_sf "#{lib}/#{shared_library("libmvtools")}", "#{lib}/vapoursynth/#{shared_library("libmvtools")}"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.mv"
  end
end
