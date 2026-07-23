class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.8.0.1/sox_ng-14.8.0.1.tar.gz"
  sha256 "7698a1b2699499b0b38fa95a15bb56c68928d97b144bce03b7ecb76fe9c46698"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a4d52ed310f5ddb396d2a235e15cefe0e5269ed00ef34c084c9bfe563d9e535"
    sha256 cellar: :any,                 arm64_sequoia: "e5bb6fa3a3aa38caca455bc76e16a50287b2ffe5746421a53bd46966517e4159"
    sha256 cellar: :any,                 arm64_sonoma:  "d4eaa4c4cbd2d3e47376c99c2e4b68907a4a6e0a2e9de04c8a3754859865ec13"
    sha256 cellar: :any,                 sonoma:        "659c665a53e183f33a82d83ec1e23f3364eea2ee291033538ea77e4f3a604f4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ed8a2459e0acfc8f49bb6d5518bf78eeb73e8aa7cf843160a19657335bb7dba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "775fc2fe7dcbd4f8df3494c625525f934202d800c3e94b7943a349519fd629ec"
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
