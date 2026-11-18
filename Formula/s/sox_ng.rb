class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.9.0/sox_ng-14.9.0.tar.gz"
  sha256 "221c59acccc55946170f5ea49968930584a2672cf3217d03dff2627bf3270502"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5e1af1240f3684cb15f4b6cc622fda12f7e7321bf575892d58ef1515f7664b9d"
    sha256 cellar: :any, arm64_tahoe:       "d05f9a2ae7d519f4f2907a6f608bf58207861940f96a5650b2a71398d1dc1300"
    sha256 cellar: :any, arm64_sequoia:     "5b328355af410375db1902a87aea45cab8432bc93b35d3fa77491c43e717f1aa"
    sha256 cellar: :any, arm64_linux:       "f23079ed79bdf162ba36d71b6b32ddd6696dd1d70972640f76badbd96fe3ebe5"
    sha256 cellar: :any, x86_64_linux:      "b4891e0296aabe1d95fbb0e9f74e0d147ca3af88b0aeeebd143ecc3090fdc842"
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

  deny_network_access!

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
