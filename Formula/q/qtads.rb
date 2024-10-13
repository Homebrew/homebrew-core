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

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6e3606d6b81aace60e22a195af69bdc1a487903f6199f66f625b5cd80063b468"
    sha256 cellar: :any,                 arm64_sonoma:   "c8737515d6dc5506c6c44f91ceba97426015e71112171006ab57f1646a4d2231"
    sha256 cellar: :any,                 arm64_ventura:  "06f702f167f0b8579f382b626a612fb14a646221420d84b605ad46738751e4bd"
    sha256 cellar: :any,                 arm64_monterey: "8bd68c471a53ce7d00aadc3fde4a51a3b86a6130a3312a326b5293b3223d253b"
    sha256 cellar: :any,                 arm64_big_sur:  "fce9e5ba4f310c2d8d6fe7929bec2779aa7651645229d0f98cf344e76fb711c3"
    sha256 cellar: :any,                 sonoma:         "b2e9db9097b1712b7d5fa30f978031048032bd18e71d0157a2ba5deaa0659dcc"
    sha256 cellar: :any,                 ventura:        "eefed02a2f64f4bb5da5f9eb9af4a47e268ef02c695d9c94ae01ae1213a1d254"
    sha256 cellar: :any,                 monterey:       "463fd847281ae7edf08b71824d36d0a87a01bd7feaefa452d132c35ccd63d68c"
    sha256 cellar: :any,                 big_sur:        "2cabcaf186de69de6790202587c6ffb6e9484106b13b0b6dea221ea46728010b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "251840532a70387d1007ab9a992bb9f6e8d6c543133fc19d5d41b0dd81c822a5"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "qt@5"
  depends_on "sdl2"

  fails_with gcc: "5"

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
    assert_predicate testpath/"#{bin}/#{bin_name}", :exist?, "I'm an untestable GUI app."
  end
end
