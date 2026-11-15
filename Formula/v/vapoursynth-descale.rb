class VapoursynthDescale < Formula
  desc "VapourSynth plugin to undo upscaling"
  homepage "https://github.com/Irrational-Encoding-Wizardry/descale"
  url "https://github.com/Irrational-Encoding-Wizardry/descale/archive/refs/tags/r8.tar.gz"
  sha256 "317d955cc2dfbc3fd1aecef2ea2d56e4f1cd99434492d71c6a1d48213ff35972"
  license "MIT"
  revision 2
  head "https://github.com/Irrational-Encoding-Wizardry/descale.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "590bae183f8ba91eb69332ad98655cb8ec16692d107546799cd78dd26df095db"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b85bec238cb4346a056228ff9a145c86be263951947c9baca0687a5823ca3b42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57407f006c35ddb7b664767a56586b02ef8c110fa101534a9abb93a9083cff94"
    sha256 cellar: :any,                 arm64_linux:       "d27ad72ab77db9916705bec025a8301277f3c61abc468af3b2fd7d04cf65355e"
    sha256 cellar: :any,                 x86_64_linux:      "a6fd93e324c706af3f460d01017ba80ce636989c38b17b1e10da7d44d95a19cd"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15"
  depends_on "vapoursynth"

  def install
    # Help outdated #includes paths find VapourSynth
    vapoursynth_dir = "#{Language::Python.site_packages(python3)}/vapoursynth"
    buildpath.install_symlink formula_opt_libexec("vapoursynth")/vapoursynth_dir/"include" => "vapoursynth"

    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
              "installdir = join_paths(vs.get_pkgconfig_variable('libdir'), 'vapoursynth')",
              "installdir = '#{prefix/vapoursynth_dir}/plugins'"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system python3, "-c", "from vapoursynth import core; core.descale"
  end
end
