class Qtads < Formula
  desc "TADS multimedia interpreter"
  homepage "https://realnc.github.io/qtads/"
  url "https://github.com/realnc/qtads/releases/download/v3.4.0/qtads-3.4.0-source.tar.xz"
  sha256 "3c8f1b47ee42d89753d68e7c804ca3677b0c89a5d765d1fd4f80f9cdc29d3473"
  license "GPL-3.0-or-later"
  head "https://github.com/realnc/qtads.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d6549a2b3f706a45c5e6e73bfc1ead1f3cd80eed681a3c713731cf6b9681ea88"
    sha256 cellar: :any,                 arm64_sequoia:  "6e3606d6b81aace60e22a195af69bdc1a487903f6199f66f625b5cd80063b468"
    sha256 cellar: :any,                 arm64_sonoma:   "c8737515d6dc5506c6c44f91ceba97426015e71112171006ab57f1646a4d2231"
    sha256 cellar: :any,                 arm64_ventura:  "06f702f167f0b8579f382b626a612fb14a646221420d84b605ad46738751e4bd"
    sha256 cellar: :any,                 arm64_monterey: "8bd68c471a53ce7d00aadc3fde4a51a3b86a6130a3312a326b5293b3223d253b"
    sha256 cellar: :any,                 arm64_big_sur:  "fce9e5ba4f310c2d8d6fe7929bec2779aa7651645229d0f98cf344e76fb711c3"
    sha256 cellar: :any,                 sonoma:         "b2e9db9097b1712b7d5fa30f978031048032bd18e71d0157a2ba5deaa0659dcc"
    sha256 cellar: :any,                 ventura:        "eefed02a2f64f4bb5da5f9eb9af4a47e268ef02c695d9c94ae01ae1213a1d254"
    sha256 cellar: :any,                 monterey:       "463fd847281ae7edf08b71824d36d0a87a01bd7feaefa452d132c35ccd63d68c"
    sha256 cellar: :any,                 big_sur:        "2cabcaf186de69de6790202587c6ffb6e9484106b13b0b6dea221ea46728010b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ca269c91add3713169db676f9f70182d210a42bf7b2b4511b8929f48e24ffe99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "251840532a70387d1007ab9a992bb9f6e8d6c543133fc19d5d41b0dd81c822a5"
  end

  # Last release on 2023-05-17, last commit on 2023-05-19.
  # PR for Qt 6 open since 2023-10-28: https://github.com/realnc/qtads/pull/21
  # Can undeprecate if new release with Qt 6 support is available.
  deprecate! date: "2026-05-19", because: "needs end-of-life Qt 5"

  depends_on "pkgconf" => :build
  depends_on "fluid-synth"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "qt@5" # Qt6 PR: https://github.com/realnc/qtads/pull/21
  depends_on "sdl2"

  def install
    args = ["DEFINES+=NO_STATIC_TEXTCODEC_PLUGINS"]
    args << "PREFIX=#{prefix}" unless OS.mac?

    system "qmake", *args
    system "make"

    if OS.mac?
      prefix.install "QTads.app"
      bin.write_exec_script "#{prefix}/QTads.app/Contents/MacOS/QTads"
    else
      system "make", "install"
    end

    man6.install "desktop/man/man6/qtads.6"
  end

  test do
    bin_name = OS.mac? ? "QTads" : "qtads"
    assert_path_exists testpath/"#{bin}/#{bin_name}", "I'm an untestable GUI app."
  end
end
