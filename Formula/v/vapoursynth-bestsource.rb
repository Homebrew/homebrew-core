class VapoursynthBestsource < Formula
  desc "Audio/video source and FFmpeg wrapper"
  homepage "https://github.com/vapoursynth/bestsource"
  url "https://github.com/vapoursynth/bestsource/archive/refs/tags/R19.tar.gz"
  sha256 "bbd391dd2725ae68994e0627f4a57b484d37b6e8d150276f07122e89fb6cda5d"
  license "MIT"
  head "https://github.com/vapoursynth/bestsource.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c0f9fad2ac580883b1205e32277755a43e470e6be01c40aaf5d6e44899687b83"
    sha256 cellar: :any, arm64_sequoia: "711010a3f65dc8f2ced09a43ccf11a10f0343ece48b206c561f2d27d55d48db2"
    sha256 cellar: :any, arm64_sonoma:  "f0ea20d2cdc59d70095725feedadd82f99a55c0675ae463f70796fdbb903c8b4"
    sha256 cellar: :any, sonoma:        "7585bb8d20a1ee3c5d3bee5106d8c19f89a74021738a412ca1a2dd87a3c45309"
    sha256               arm64_linux:   "ec199778d4513477bc7ba668d47008ad7df2c75f24cc8703800d29587370ed99"
    sha256               x86_64_linux:  "a0e19fe34f7c112a3077526d2bde45fc26a144e5a7dd7cb26863e34cffb98342"
  end

  depends_on "avisynthplus" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "python@3.14"
  depends_on "vapoursynth"
  depends_on "xxhash"

  resource "libp2p" do
    url "https://github.com/sekrit-twc/libp2p/archive/869fa993041f9f3af7d9ac8b10158920c6ddce66.tar.gz"
    sha256 "cacef2683a19a8b288cf567544b507f7f06dd66160db566bf3349e5ee0b73d90"
  end

  deny_network_access!

  def python3 = "python3.14"

  def install
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    resource("libp2p").stage("subprojects/libp2p")
    (buildpath/"subprojects/libp2p").install "subprojects/packagefiles/libp2p/meson.build"

    # upstream expects a subproject, but we can build with our avisynthplus instead
    avisynth_pc = formula_opt_lib("avisynthplus")/"pkgconfig/avisynth.pc"
    (buildpath/"pkgconfig").install_symlink avisynth_pc => "avisynthplus.pc"
    ENV.append_path "PKG_CONFIG_PATH", buildpath/"pkgconfig"

    # Work around Homebrew's python prefix patch
    args = %W[-Dpython.platlibdir=#{prefix/Language::Python.site_packages(python3)}]

    # Using nodownload as nofallback with `--force-fallback-for` can download HEAD git repos
    system "meson", "setup", "build", *args, *std_meson_args, "--wrap-mode=nodownload"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from vapoursynth import core
      print(core.bs.TrackInfo("#{test_fixtures("test.mp4")}")["codecstr"])
    PYTHON
    assert_equal "h264", shell_output("#{python3} test.py").chomp
  end
end
