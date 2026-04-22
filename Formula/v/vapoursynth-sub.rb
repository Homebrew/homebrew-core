class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/subtext/archive/refs/tags/R6.tar.gz"
  sha256 "536e2f056c7b318b0104b8b9050bb17c00d8ca60b0e5fdecf1ee92879c5f9165"
  license "MIT"
  version_scheme 1
  head "https://github.com/vapoursynth/subtext.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1dd9d606c3dc95220bd01768d3915b93ab012db6948741cf7eec09bdbe3e4a85"
    sha256 cellar: :any, arm64_sequoia: "3a1306e4e00e4e2631402a144aec9fa28901e7a673cd465506305da5e3a7e139"
    sha256 cellar: :any, arm64_sonoma:  "499a8f53ac127e63fb8057db07100fdbc2e577feaeb5d281a52b4dea5a3f940a"
    sha256 cellar: :any, sonoma:        "6431bf13a69ca6b48151dd5acbf301d969f7dba02710f6db9afd502dce711eb9"
    sha256               arm64_linux:   "6cba3bd1647da2fe3c4784b57a79dd0392f23aba641567ce64f4543ab62f1369"
    sha256               x86_64_linux:  "d1b277613210ac4fcd61d6f09ef9c5a81feb45001c7569bfef090e3cfd580b49"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libass"
  depends_on "vapoursynth"

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build" do |s|
      s.gsub!(/^incdir = include_directories\(.*?^\)/m,
              "incdir = include_directories('#{Formula["vapoursynth"].opt_include}/vapoursynth')")
      s.gsub! "install_dir: py.get_install_dir() / 'vapoursynth/plugins'", "install_dir: '#{lib}/vapoursynth'"
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.sub"
  end
end
