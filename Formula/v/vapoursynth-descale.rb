class VapoursynthDescale < Formula
  desc "VapourSynth plugin to undo upscaling"
  homepage "https://github.com/Irrational-Encoding-Wizardry/descale"
  url "https://github.com/Irrational-Encoding-Wizardry/descale/archive/refs/tags/r8.tar.gz"
  sha256 "317d955cc2dfbc3fd1aecef2ea2d56e4f1cd99434492d71c6a1d48213ff35972"
  license "MIT"
  revision 1
  head "https://github.com/Irrational-Encoding-Wizardry/descale.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f9634605ee0f4847576315b231184694138b1acde8092705e3bb465b4bb3a06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baa8d37ca8fb30b658a49831fff0dd09b3fb74163f655b4fb742e55f619a216d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99889b5ab38fbfccc54913f103d37fab1a32161e4fba2244b701e186a0760c53"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4ee93781befa25edce1bc69a12f772643b1369b5a0fecfbdb0dc70a3c779788"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0733d5b06a7a860adb8ebd3a8f951fa1f87d7bd876bdde302334899c7ff91b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "449087686e60c7ee1d59cc82290c791c139d7210aea8e936f6a099b071282f71"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14"
  depends_on "vapoursynth"

  def python3 = "python3.14"

  def install
    # Help outdated #includes paths find VapourSynth
    vapoursynth_include = Formula["vapoursynth"].libexec/Language::Python.site_packages(python3)/"vapoursynth/include"
    buildpath.install_symlink vapoursynth_include => "vapoursynth"

    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
              "installdir = join_paths(vs.get_pkgconfig_variable('libdir'), 'vapoursynth')",
              "installdir = '#{prefix/Language::Python.site_packages(python3)}/vapoursynth/plugins'"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system python3, "-c", "from vapoursynth import core; core.descale"
  end
end
