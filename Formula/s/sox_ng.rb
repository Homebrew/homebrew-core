class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.8.1/sox_ng-14.8.1.tar.gz"
  sha256 "1dedd9ad574abc576bbda06743867fb778accf98a1eacde1a42913acbf072448"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dad7a21094e7631c66e137f3024de627dbeb35e528120dff206dccf8551e6244"
    sha256 cellar: :any, arm64_tahoe:       "a9481f718eb294147d57280662c9f696d8a73b560be4cd3ba6ee4de7d9114756"
    sha256 cellar: :any, arm64_sequoia:     "b974f68f8218d5d255667ad2a34be8c9d3a8558b0b01c2555956cb51dbed6806"
    sha256 cellar: :any, arm64_sonoma:      "7ee9392ed3a945b9c5308a35a0e6d0ce306d30adbe22c5b3da9432fcdd5f2328"
    sha256 cellar: :any, arm64_linux:       "b8b7b8e6ab3cee3be0988ac9136951e1a36791ca23c5b8a13f898a251c9ecb67"
    sha256 cellar: :any, x86_64_linux:      "b10d761996d46680e7817a5f66101d8b90dfec39c07aa18d1637cc3ed0dc1e67"
  end

  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "opusfile"
  depends_on "wavpack"

  on_macos do
    depends_on "opus"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "sox", because: "both install `play`, `rec`, `sox`, `soxi` binaries"

  def install
    args = %w[--enable-replace]
    args << "--with-alsa" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    input = testpath/"test.wav"
    output = testpath/"concatenated.wav"
    cp test_fixtures("test.wav"), input
    system bin/"sox", input, input, output
    assert_path_exists output
  end
end
