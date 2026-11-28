class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.9.0.1/sox_ng-14.9.0.1.tar.gz"
  sha256 "0e17171b4a4963f431419c234ea81612bb4c5d2d44d934954abc0e4498d8863b"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "aee04b5bdfbd9ab7a4ff27e2ccfd03bcb169ced9787725b7dcc3caea9c250f7f"
    sha256 cellar: :any, arm64_golden_gate: "cb2ca76a951f380bc4ae711cb4f9ce60ac729ab1a2e15db57db6c4679183b149"
    sha256 cellar: :any, arm64_tahoe:       "fa3a99a096142e1a6283f3313a96d7c4908d6ecaf8d18d93d828721532685eb6"
    sha256 cellar: :any, arm64_sequoia:     "43dc0f9b2c19fa335ad28a3e66d59c3e869e508a7c43a583dbaadea4fea069fa"
    sha256 cellar: :any, arm64_linux:       "f9631eef0bf3ed994011199ac4dca0a7f10a209e8a98e0955ce164c2653b2651"
    sha256 cellar: :any, x86_64_linux:      "3532121ae767f95b49939226f0fd6ea271f36e32582537de104690b7a18c6987"
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
