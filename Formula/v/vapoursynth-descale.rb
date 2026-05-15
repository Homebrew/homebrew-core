class VapoursynthDescale < Formula
  desc "VapourSynth plugin to undo upscaling"
  homepage "https://github.com/Irrational-Encoding-Wizardry/descale"
  url "https://github.com/Irrational-Encoding-Wizardry/descale/archive/refs/tags/r8.tar.gz"
  sha256 "317d955cc2dfbc3fd1aecef2ea2d56e4f1cd99434492d71c6a1d48213ff35972"
  license "MIT"
  head "https://github.com/Irrational-Encoding-Wizardry/descale.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "367adf1613ed0354d8a93588f765437e072bc9c2fcfa7cd8cbcef9291f38475d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9faad8e0a5ee9b78fbe86a7119fae7b316f96565f2ab72881f42301f5bcfa931"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b77deed08ec1f7fa494acb387ea8af43a2a81afb2aee8431c6b30b27f5f63f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "46b58d656b8b7a374e1a759ca4e10e786d29356084308ed06d97f9919c56ce7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "268756b29d7c04d9f28f6142462a51c77d6ab779b06011d12b42e6c71f18e279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b57118f0638ab218aadc619c10a0790d97676ee8f0fee8de3ae9e8daf027fc8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vapoursynth"

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
              "installdir = join_paths(vs.get_pkgconfig_variable('libdir'), 'vapoursynth')",
              "installdir = '#{lib}/vapoursynth'"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.descale"
  end
end
