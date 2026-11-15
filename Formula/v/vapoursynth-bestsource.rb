class VapoursynthBestsource < Formula
  desc "Audio/video source and FFmpeg wrapper"
  homepage "https://github.com/vapoursynth/bestsource"
  url "https://github.com/vapoursynth/bestsource/archive/refs/tags/R23.tar.gz"
  sha256 "1cbc9586bd83668be130b2d69faa46448d3f6a2e2c075dae2977a87358e8986b"
  license "MIT"
  compatibility_version 1
  head "https://github.com/vapoursynth/bestsource.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8a83450bb6659509b78f57c137a5796d78c43245066fa187cfe427b8b7bf4fd6"
    sha256 cellar: :any, arm64_tahoe:       "d8aa49b70135998fd2ec0d9b67b6044a709cc4bc1b19a05a61e91fdae7712e2b"
    sha256 cellar: :any, arm64_sequoia:     "5c941a7240dbfb5ac9b75d8a06d1bedf552844b0f02a456bb15df77aebddd708"
    sha256 cellar: :any, arm64_linux:       "52c9a753b99e12e5d05896c54542c8643288610647aab2abdf7ef0e973664180"
    sha256 cellar: :any, x86_64_linux:      "f7d31522be39c19bb4fdee8b3199f12b883de5740bfba4099fbfbcea54efd1c9"
  end

  depends_on "avisynthplus" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "python@3.15"
  depends_on "vapoursynth"
  depends_on "xxhash"

  resource "libp2p" do
    url "https://github.com/sekrit-twc/libp2p/archive/869fa993041f9f3af7d9ac8b10158920c6ddce66.tar.gz"
    sha256 "cacef2683a19a8b288cf567544b507f7f06dd66160db566bf3349e5ee0b73d90"
  end

  deny_network_access!

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
