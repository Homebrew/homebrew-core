class VapoursynthBestsource < Formula
  desc "Audio/video source and FFmpeg wrapper"
  homepage "https://github.com/vapoursynth/bestsource"
  url "https://github.com/vapoursynth/bestsource/archive/refs/tags/R22.tar.gz"
  sha256 "8233ecf8f1bbc9edb2330ce0e0cf79a5f821220a95750edbcddf2fb0b46c0ed2"
  license "MIT"
  revision 1
  head "https://github.com/vapoursynth/bestsource.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7603309bdde52cf876abe7ed793d43ce1c60a5a6b2b087fa32c03ac54073b20a"
    sha256 cellar: :any, arm64_tahoe:       "cc28e0c145c65412c0dd187225261c385811cfa9a772ca5fd107f81db1a814b9"
    sha256 cellar: :any, arm64_sequoia:     "0eb09fd4c408557556bc435be0751e7f18c0ebd5938d0ba48e0700f5a594fa22"
    sha256 cellar: :any, arm64_linux:       "4ea7d9906c16735d7f013bc0110209b26fb63d27d981058ff8f20466a98269dc"
    sha256 cellar: :any, x86_64_linux:      "0a33cdd216b09a58cc4ec4da793d4f4e1519d0389ffc329ee9c9e150084b3472"
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
