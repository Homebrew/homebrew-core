class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.7.0.1/sox_ng-14.7.0.1.tar.gz"
  sha256 "8f2af178a11a3f664121c916af6428e42a5000bc018056b2f4a2c8dad0f339c9"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aa92f5e3998c0bf98b7bc9bfb287ea059fa22e0ca844dbe122633465a4cce53b"
    sha256 cellar: :any,                 arm64_sequoia: "e9c904960918bbcae2308738b7a490b55b059af51bc579fa186da2cabcb454a3"
    sha256 cellar: :any,                 arm64_sonoma:  "a58e155a6ccf795e52468a8ed4e549092b26a84dba30a576e5c84970d98826b4"
    sha256 cellar: :any,                 sonoma:        "77677674f1ccbe30410ec23272b55d9a1d7b9c1b1a1862cd6af8ddc99da12094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bef90c6f9db1003a45180e41a4f7bb2130da2656ab2fab3025f118bb8973a5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23f8ce03cd24df640f66c24ca95c698df5a0c68ed8796de4a23754e9fa0b262b"
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
