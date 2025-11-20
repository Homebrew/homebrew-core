class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.7.0/sox_ng-14.7.0.tar.gz"
  sha256 "3c7258bc20dc2af628f1633d5db053698d433d4fc3b5219cf9bb4946a9d34d50"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9ba6dc1caf95e02be682995a4520d2ff237ef1352288d17624845ebd7ae8534"
    sha256 cellar: :any,                 arm64_sequoia: "d7141d262477872d53495d09befe097f8db69ba8ca21aa9dbab67ed35a56496a"
    sha256 cellar: :any,                 arm64_sonoma:  "a0cd2ded4217b581b218545f53168fd45d12705487f362da53f61f8bb5c86f7f"
    sha256 cellar: :any,                 sonoma:        "d80b356e8dd39aa826eb0da5c04ef7d2996d30cc3f2eb0b5e011fafe6f857b0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d871413f60b8d0a689b71494d9d55704b0ff13acb85bfa673f26fd6a50216f6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a342d1f0cb5eb40e33960677a93e79cec5fce6019a82eb1a32efd691595c647"
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

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
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
